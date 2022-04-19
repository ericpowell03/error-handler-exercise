class CustomError < StandardError
  attr_reader :status_code, :status

  def initialize(msg = nil, status_code: nil, status: nil)
    @status_code = status_code
    @status = status
    super(msg)
  end
end

class SampleClass
  include ErrorHandler

  handle_exception StandardError
  handle_exception CustomError

  def standard_error_method
    handle_errors do
      raise StandardError
      puts 'This will NOT be executed'
    end
    puts 'This will be executed'
  end

  def override_error_handling_rule
    rule = self.class.exception_handling_rules[0]
    handle_errors(except: rule) do
      raise StandardError
    end
  end

  def override_multiple_rules
    handle_errors(except: self.class.exception_handling_rules) do
      raise CustomError
    end
  end
end

class SampleErrorMessageClass
  include ErrorHandler
  handle_exception StandardError, "Ignore specific message for Standard Error"

  def should_be_ignored
    handle_errors do
      raise StandardError, 'Ignore specific message for Standard Error'
    end
  end

  def should_not_be_ignored
    handle_errors do
      raise StandardError
    end
  end
end


class SampleAttributeErrorClass
  include ErrorHandler

  handle_exception CustomError, nil, status_code: 404, status: :not_found

  def should_be_ignored
    handle_errors do
      raise CustomError.new(status_code: 404, status: :not_found)
    end
  end

  def should_not_be_ignored
    handle_errors do
      raise CustomError
    end
  end
end

class SampleMessageOnlyErrorClass
  include ErrorHandler

  handle_exception nil, 'Custom error message to handle'

  def should_be_ignored
    handle_errors do
      raise CustomError, 'Custom error message to handle'
    end
  end
end

class SampleAttributeOnlyErrorClass
  include ErrorHandler

  handle_exception nil, nil, status_code: 404

  def should_be_ignored
    handle_errors do
      raise CustomError.new('Custom error message to handle', status_code: 404)
    end
  end
end
class SampleErrorMessageClass
  include ErrorHandler
  handle_exception StandardError, "Ignore specific message for Standard Error"

  def should_be_ignored
    handle_errors do
      raise StandardError.new "Ignore specific message for Standard Error"
    end
  end

  def should_not_be_ignored
    handle_errors do
      raise StandardError
    end
  end
end
class CustomError < StandardError
  attr_reader :status_code, :status

  def initialize(msg = nil, status_code: nil, status: nil)
    @status_code = status_code
    @status = status
    super(msg)
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

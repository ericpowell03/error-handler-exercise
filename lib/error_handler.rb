# Define rules to conditionally swallow exceptions that occur within a given block of code
module ErrorHandler
  # How To:
  # 1: Include the ErrorHandler module in your class
  # 2. Define rules using handle_exception
  # 3. Handle errors by wrapping code in a block passed to handle_errors
  #
  # Example:
  #
  # class MyClass
  #   include ErrorHandler

  #   # Rule Examples:
  #   handle_exception StandardError

  #   # Must match the error class && message to be handled
  #   # handle_exception CustomError, 'Custom error message'
  #   # Must match the error class, message, && attributes to be handled
  #   # handle_exception CustomError, 'Custom error message', status_code: 404, status: :not_found
  #   # Attributes (if they exist), must all match on any error class
  #   # handle_exception nil, nil, status_code: 404, status: :not_found
  #   # The message must match, but on any class
  #   # handle_exception nil, 'Custom error message'

  #   # Any code within the block that matches the rule will be rescued
  #   def perform
  #     handle_errors do
  #       puts "Do work..."
  #       # This error will be rescued
  #       raise StandardError
  #       # This code will NOT execute, because the block is returned
  #       # once the handled error is raised
  #       puts 'This will not execute.'
  #     end
  #     # This code will execute if a handled error is raised within
  #     # the handle_errors block because the block returns after a handled error.
  #     puts 'This will execute.'
  #   end

  #   # You may override any number of rules by passing a rule (or an array of rules)
  #   # via the 'except' arg when calling handle_errors.
  #   # Example:
  #   def exclude_a_rule
  #     do_not_handle = {klass: StandardError, message: nil, attributes: {}}
  #     handle_errors(except: do_not_handle) do
  #       puts 'The error rule do_not_handle will NOT be ignored if raised'
  #       # This error will be raised and will halt execution.
  #       raise StandardError
  #     end
  #   end
  # end

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def handle_exception(klass = nil, message = nil, **attributes)
      @exception_handling_rules ||= []
      @exception_handling_rules << { klass: klass, message: message, attributes: attributes }
    end

    def exception_handling_rules
      @exception_handling_rules
    end

    def handle_exception?(exception, rule)
      klass_match = rule[:klass].nil? || rule[:klass] == exception.class
      message_match = rule[:message].nil? || exception_matches_message_rule?(exception, rule)
      attribute_match = rule[:attributes].empty? || exception_matches_attribute_rules?(exception, rule)
      klass_match && message_match && attribute_match
    end

    private

    def exception_matches_message_rule?(exception, rule)
      case rule[:message]
      when String
        exception.message.include?(rule[:message])
      when Regexp
        exception.message.match(rule[:message])
      end
    end

    def exception_matches_attribute_rules?(exception, rule)
      rule[:attributes].map do |key, value|
        exception.methods.include?(key) && exception.send(key) == value
      end.all?
    end
  end

  def handle_errors(except: nil)
    yield
  rescue => e
    ([self.class.exception_handling_rules].flatten - [except].flatten).each do |rule|
      return if self.class.handle_exception?(e, rule)
    end

    raise e
  end
end

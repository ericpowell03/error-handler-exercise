module ErrorHandler
  # #handle_errors should accept a block as an argument that will execute
  # code in the block and conditionally swallow errors given the defined rules
  #
  # Example:
  #
  # class MyClass
  #   include ErrorHandler
  #
  #   def perform
  #     handle_errors do
  #       puts "Do work..."
  #     end
  #   end
  # end

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    @@exception_handling_rules = Array.new
    
    def handle_exception(klass = nil, message = nil, **attributes)
      @@exception_handling_rules << { klass: klass, message: message, attributes: attributes }
    end

    def exception_handling_rules
      @@exception_handling_rules
    end
  end

  def handle_errors(except: nil)
    begin
      yield
    rescue => exception 
      self.class.exception_handling_rules.each do |rule|
        return if handle_exception?(exception, rule)
      end

      raise exception
    end
  end

  def handle_exception?(exception, rule)
    klass_match = rule[:klass].nil? || rule[:klass] == exception.class
    message_match = rule[:message].nil? || exception_message_matches_rule?(exception, rule)
    attribute_match = rule[:attributes].nil? || exception_matches_attribute_rules?(exception, rule)
    klass_match && message_match && attribute_match
  end

  def exception_matches_message_rules?(exception, rule)
    if rule[:message].is_a?(String)
      exception.message.include?(rule[:message])
    elsif rule[:message].is_a?(Regexp)
      exception.message.match(rule[:message])
    end
  end

  def exception_matches_attribute_rules?(exception, rule)
    rule[:attributes].map do |key, value|
      exception.methods.include?(key) && exception.send(key) == value
    end.all?
  end
end

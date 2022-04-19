require 'error_handler'
require 'byebug'
require_relative '../spec/support/sample_classes'

describe ErrorHandler do
  it "is an object" do
    expect(ErrorHandler).to be_a(Object)
  end

  it "is an object" do
    expect(SampleClass).to be_a(Object)
    expect(SampleErrorMessageClass).to be_a(Object)
  end
  
  it 'should not raise an error' do
    sample = SampleClass.new
    expect { sample.standard_error_method }.not_to raise_error
    expect { sample.standard_error_method }.to output("This will be executed\n").to_stdout
  end

  it 'should raise an error when explicitly excluding the rule with handle_errors' do
    sample = SampleClass.new
    expect { sample.override_error_handling_rule }.to raise_error(StandardError)
  end

  it 'should not raise an error when the message rule and class matches' do
    sample = SampleErrorMessageClass.new
    expect { sample.should_be_ignored }.not_to raise_error
  end

  it 'should raise an error when the class matches but message does not' do
    sample = SampleErrorMessageClass.new
    expect { sample.should_not_be_ignored }.to raise_error(StandardError)
  end

  it 'should raise an error when the class and attributes all match' do
    sample = SampleAttributeErrorClass.new
    expect { sample.should_be_ignored }.not_to raise_error
  end

  it 'should not raise an error when the class matches but the provided attributes do not' do
    sample = SampleAttributeErrorClass.new
    expect { sample.should_not_be_ignored }.to raise_error(CustomError)
  end
end

class SampleClass
  include ErrorHandler

  handle_exception StandardError

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
end

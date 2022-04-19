require 'error_handler'
require 'byebug'
require_relative '../spec/support/sample_classes'

describe ErrorHandler do
  it "is an object" do
    expect(ErrorHandler).to be_a(Object)
    expect(SampleClass).to be_a(Object)
  end

  describe 'With a class-only exception rule' do
    it 'should not raise an error if the error class is raised' do
      sample = SampleClass.new
      expect { sample.standard_error_method }.not_to raise_error
      expect { sample.standard_error_method }.to output("This will be executed\n").to_stdout
    end
  end

  describe 'When over-riding rules with handle_errors(except: )' do
    it 'should raise an error when passing single rule' do
      sample = SampleClass.new
      expect { sample.override_error_handling_rule }.to raise_error(StandardError)
    end

    it 'should raise an error when passing multiple rules via array' do
      sample = SampleClass.new
      expect { sample.override_multiple_rules }.to raise_error(CustomError)
    end
  end

  describe 'With rules that include both class and message' do
    it 'should not raise an error when the both match' do
      sample = SampleErrorMessageClass.new
      expect { sample.should_be_ignored }.not_to raise_error
    end

    it 'should raise an error when the class matches but message does not' do
      sample = SampleErrorMessageClass.new
      expect { sample.should_not_be_ignored }.to raise_error(StandardError)
    end

    it 'should raise an error when the message matches but class does not' do
      sample = SampleErrorMessageClass.new
      expect { sample.should_be_ignored_for_message_mismatch }.to raise_error(CustomError)
    end
  end

  describe 'With a rule that uses a class and attributes' do
    it 'should raise an error when the class and attributes all match' do
      sample = SampleAttributeErrorClass.new
      expect { sample.should_be_ignored }.not_to raise_error
    end

    it 'should not raise an error when the class matches but the provided attributes do not' do
      sample = SampleAttributeErrorClass.new
      expect { sample.should_not_be_ignored }.to raise_error(CustomError)
    end
  end

  describe 'With a rule that only includes a message' do
    let(:sample) { SampleMessageOnlyErrorClass.new }

    it 'should not raise an error when the message matches' do
      expect { sample.should_be_ignored }.not_to raise_error
    end

    it 'should raise an error when the message does not match' do
      expect { sample.should_not_be_ignored }.to raise_error(CustomError)
    end

    it 'should ignore the error if the regex matches the message' do
      expect { sample.regex_message_should_be_ignored }.not_to raise_error
    end

    it 'should raise the error if the regex does not match' do
      expect { sample.regex_message_should_not_be_ignored }.to raise_error(CustomError)
    end
  end

  describe 'With a rule that includes only error attributes' do
    it 'should not raise an error for an error if all attributes match' do
      sample = SampleAttributeOnlyErrorClass.new
      expect { sample.should_be_ignored }.not_to raise_error
    end

    it 'should raise an error if some but not all attrs match' do
      sample = SampleAttributeOnlyErrorClass.new
      expect { sample.should_not_be_ignored }.to raise_error(CustomError)
    end
  end

  it 'should allow the module to be added to the parent class and invoked on the child' do
    expect(ParentClass.exception_handling_rules).to be_nil
    expect(ChildClass.exception_handling_rules.length).to eq(1)
    expect { ChildClass.new.should_not_raise_error }.not_to raise_error
  end

  it 'should allow a class to call handle_errors without any rules set' do
    parent = ParentClass.new
    expect { parent.should_raise_custom_error }.to raise_error(CustomError)
  end
end

require "error_handler"
require 'byebug'

describe ErrorHandler do
  it "is an object" do
    expect(ErrorHandler).to be_a(Object)
  end

  it "is an object" do
    expect(SampleClass).to be_a(Object)
  end
  
  it 'should not raise an error' do
    sample = SampleClass.new
    expect { sample.standard_error_method }.not_to raise_error
    expect { sample.standard_error_method }.to output("This will be executed\n").to_stdout
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
end
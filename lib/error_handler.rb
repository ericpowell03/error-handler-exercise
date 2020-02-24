module ErrorHandler
  # TODO: implementation
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
  def handle_errors
    yield
  end
end

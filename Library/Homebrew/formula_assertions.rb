module Homebrew
  module Assertions
    if defined?(Gem)
      begin
        gem "minitest", "< 5.0.0"
      rescue Gem::LoadError
        require "test/unit/assertions"
      else
        require "minitest/unit"
        require "test/unit/assertions"
      end
    else
      require "test/unit/assertions"
    end

    if defined?(MiniTest::Assertion)
      FailedAssertion = MiniTest::Assertion
    elsif defined?(Minitest::Assertion)
      FailedAssertion = Minitest::Assertion
    else
      FailedAssertion = Test::Unit::AssertionFailedError
    end

    include ::Test::Unit::Assertions

    # Returns the output of running cmd, and asserts the exit status
    def shell_output(cmd, result = 0)
      ohai cmd
      output = `#{cmd}`
      assert_equal result, $?.exitstatus
      output
    end

    # Returns the output of running the cmd with the optional input, and
    # optionally asserts the exit status
    def pipe_output(cmd, input = nil, result = nil)
      ohai cmd
      output = IO.popen(cmd, "w+") do |pipe|
        pipe.write(input) unless input.nil?
        pipe.close_write
        pipe.read
      end
      assert_equal result, $?.exitstatus unless result.nil?
      output
    end
  end
end

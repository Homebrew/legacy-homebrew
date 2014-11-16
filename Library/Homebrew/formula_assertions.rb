require 'test/unit/assertions'

module Homebrew
  module Assertions
    include Test::Unit::Assertions

    # Returns the output of running cmd, and asserts the exit status
    def shell_output(cmd, result=0)
      ohai cmd
      output = `#{cmd}`
      assert_equal result, $?.exitstatus
      output
    end

    # Returns the output of running the cmd, with the optional input
    def pipe_output(cmd, input=nil)
      ohai cmd
      IO.popen(cmd, "w+") do |pipe|
        pipe.write(input) unless input.nil?
        pipe.close_write
        pipe.read
      end
    end
  end
end

require "testing_env"
require "sandbox"

class SandboxTest < Homebrew::TestCase
  def setup
    skip "sandbox not implemented" unless Sandbox.available?
    @sandbox = Sandbox.new
    @dir = Pathname.new(mktmpdir)
    @file = @dir/"foo"
  end

  def teardown
    @dir.rmtree
  end

  def test_allow_write
    @sandbox.allow_write @file
    @sandbox.exec "touch", @file
    assert_predicate @file, :exist?
  end

  def test_deny_write
    shutup do
      assert_raises(ErrorDuringExecution) { @sandbox.exec "touch", @file }
    end
    refute_predicate @file, :exist?
  end
end

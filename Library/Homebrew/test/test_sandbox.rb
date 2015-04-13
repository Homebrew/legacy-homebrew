require "testing_env"
require "sandbox"

class SandboxTest < Homebrew::TestCase
  def setup
    skip "sandbox not implemented" unless Sandbox.available?
  end

  def test_allow_write
    s = Sandbox.new
    testpath = Pathname.new(TEST_TMPDIR)
    foo = testpath/"foo"
    s.allow_write foo
    s.exec "touch", foo
    assert_predicate foo, :exist?
    foo.unlink
  end

  def test_deny_write
    s = Sandbox.new
    testpath = Pathname.new(TEST_TMPDIR)
    bar = testpath/"bar"
    shutup do
      assert_raises(ErrorDuringExecution) { s.exec "touch", bar }
    end
    refute_predicate bar, :exist?
  end
end

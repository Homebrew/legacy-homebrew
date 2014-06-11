require 'testing_env'
require 'test/testball'
require 'cmd/cleanup'

class CleanupTests < Homebrew::TestCase
  def test_cleanup
    f1 = Class.new(TestBall) { version '0.1' }.new
    f2 = Class.new(TestBall) { version '0.2' }.new
    f3 = Class.new(TestBall) { version '0.3' }.new

    shutup do
      f1.brew { f1.install }
      f2.brew { f2.install }
      f3.brew { f3.install }
    end

    assert f1.installed?
    assert f2.installed?
    assert f3.installed?

    shutup { Homebrew.cleanup_formula(f3) }

    assert !f1.installed?
    assert !f2.installed?
    assert f3.installed?
  end
end

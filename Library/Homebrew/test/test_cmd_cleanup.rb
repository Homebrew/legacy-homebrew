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

    assert_predicate f1, :installed?
    assert_predicate f2, :installed?
    assert_predicate f3, :installed?

    shutup { Homebrew.cleanup_formula(f3) }

    refute_predicate f1, :installed?
    refute_predicate f2, :installed?
    assert_predicate f3, :installed?
  ensure
    [f1, f2, f3].each(&:clear_cache)
    f3.rack.rmtree
  end
end

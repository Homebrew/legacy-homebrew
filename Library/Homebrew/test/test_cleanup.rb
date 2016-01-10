require "testing_env"
require "testball"
require "cleanup"
require "fileutils"
require "pathname"

class CleanupTests < Homebrew::TestCase
  def setup
    @ds_store = Pathname.new "#{HOMEBREW_PREFIX}/Library/.DS_Store"
    FileUtils.touch @ds_store
  end

  def teardown
    FileUtils.rm_f @ds_store
    ARGV.delete "--dry-run"
    ARGV.delete "--prune=all"
  end

  def test_cleanup
    shutup { Homebrew::Cleanup.cleanup }
    refute_predicate @ds_store, :exist?
  end

  def test_cleanup_dry_run
    ARGV << "--dry-run"
    shutup { Homebrew::Cleanup.cleanup }
    assert_predicate @ds_store, :exist?
  end

  def test_cleanup_formula
    f1 = Class.new(Testball) { version "0.1" }.new
    f2 = Class.new(Testball) { version "0.2" }.new
    f3 = Class.new(Testball) { version "0.3" }.new

    shutup do
      f1.brew { f1.install }
      f2.brew { f2.install }
      f3.brew { f3.install }
    end

    assert_predicate f1, :installed?
    assert_predicate f2, :installed?
    assert_predicate f3, :installed?

    shutup { Homebrew::Cleanup.cleanup_formula f3 }

    refute_predicate f1, :installed?
    refute_predicate f2, :installed?
    assert_predicate f3, :installed?
  ensure
    [f1, f2, f3].each(&:clear_cache)
    f3.rack.rmtree
  end

  def test_cleanup_logs
    path = (HOMEBREW_LOGS/"delete_me")
    path.mkpath
    ARGV << "--prune=all"
    shutup { Homebrew::Cleanup.cleanup_logs }
    refute_predicate path, :exist?
  end

  def test_cleanup_cache_incomplete_downloads
    incomplete = (HOMEBREW_CACHE/"something.incomplete")
    incomplete.mkpath
    shutup { Homebrew::Cleanup.cleanup_cache }
    refute_predicate incomplete, :exist?
  end

  def test_cleanup_cache_java_cache
    java_cache = (HOMEBREW_CACHE/"java_cache")
    java_cache.mkpath
    shutup { Homebrew::Cleanup.cleanup_cache }
    refute_predicate java_cache, :exist?
  end
end

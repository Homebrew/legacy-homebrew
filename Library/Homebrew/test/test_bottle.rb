require "testing_env"
require "cmd/bottle"

class BottleTests < Homebrew::TestCase
  def test_most_recent_mtime_with_broken_symlink()
    refute_nil Homebrew.most_recent_mtime(Pathname(File.join(TEST_DIRECTORY, 'resources/source-with-broken-symlink')))
  end
end

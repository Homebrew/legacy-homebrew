require "testing_env"
require "cmd/bottle"
require "formula"

class BottleTests < Homebrew::TestCase
  def test_most_recent_mtime_with_broken_symlink()
    refute_nil Homebrew.most_recent_mtime(Pathname(File.join(TEST_DIRECTORY, 'resources/source-with-broken-symlink')))
  end

  def test_initialize_with_tag
    f = formula do
      url "https://example.com/foo-1.0.tgz"

      bottle do
        sha256 TEST_SHA256 => :sometag
      end
    end

    b = Bottle.new f, f.bottle_specification, :sometag
    assert_match ".sometag.bottle.tar.gz", b.resource.url
  end
end

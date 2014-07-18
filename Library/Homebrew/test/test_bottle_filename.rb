require "testing_env"
require "software_spec"

class BottleFilenameTests < Homebrew::TestCase
  def fn(revision)
    Bottle::Filename.new("foo", "1.0", :tag, revision)
  end

  def test_to_str
    expected = "foo-1.0.tag.bottle.tar.gz"
    assert_equal expected, fn(0).to_s
    assert_equal expected, fn(0).to_str
  end
end

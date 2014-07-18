require "testing_env"
require "software_spec"

class BottleFilenameTests < Homebrew::TestCase
  def fn(revision)
    Bottle::Filename.new("foo", "1.0", :tag, revision)
  end

  def test_prefix_suffix
    assert_equal "foo-1.0.tag", fn(0).prefix
    assert_equal ".bottle.tar.gz", fn(0).suffix
    assert_equal ".bottle.1.tar.gz", fn(1).suffix
  end

  def test_to_str
    expected = "foo-1.0.tag.bottle.tar.gz"
    assert_equal expected, fn(0).to_s
    assert_equal expected, fn(0).to_str
  end
end

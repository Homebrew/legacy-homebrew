require "testing_env"
require "formula"
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

  def test_create
    f = formula do
      url "https://example.com/foo.tar.gz"
      version "1.0"
    end

    expected = "formula_name-1.0.tag.bottle.tar.gz"
    assert_equal expected, Bottle::Filename.create(f, :tag, 0).to_s
  end
end

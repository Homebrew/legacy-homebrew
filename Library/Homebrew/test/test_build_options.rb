require "testing_env"
require "build_options"
require "options"

class BuildOptionsTests < Homebrew::TestCase
  def setup
    args = Options.create(%w[--with-foo --with-bar --without-qux])
    opts = Options.create(%w[--with-foo --with-bar --without-baz --without-qux])
    @build = BuildOptions.new(args, opts)
  end

  def test_include
    assert_includes @build, "with-foo"
    refute_includes @build, "with-qux"
    refute_includes @build, "--with-foo"
  end

  def test_with_without
    assert @build.with?("foo")
    assert @build.with?("bar")
    assert @build.with?("baz")
    assert @build.without?("qux")
    assert @build.without?("xyz")
  end

  def test_used_options
    assert_includes @build.used_options, "--with-foo"
    assert_includes @build.used_options, "--with-bar"
  end

  def test_unused_options
    assert_includes @build.unused_options, "--without-baz"
  end
end

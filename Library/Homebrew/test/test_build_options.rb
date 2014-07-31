require 'testing_env'
require 'build_options'

class BuildOptionsTests < Homebrew::TestCase
  def setup
    args = %w{--with-foo --with-bar --without-qux}
    @build = BuildOptions.new(args)
    @build.add("with-foo")
    @build.add("with-bar")
    @build.add("without-baz")
    @build.add("without-qux")
  end

  def test_as_flags
    assert_equal %w{--with-foo --with-bar --without-baz --without-qux}.sort,
      @build.as_flags.sort
  end

  def test_has_option?
    assert @build.has_option?("with-foo")
    assert !@build.has_option?("with-qux")
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
  end

  def test_used_options
    assert_includes @build.used_options, "--with-foo"
    assert_includes @build.used_options, "--with-bar"
  end

  def test_unused_options
    assert_includes @build.unused_options, "--without-baz"
  end

  def test_copies_do_not_share_underlying_options
    orig = BuildOptions.new []
    copy = orig.dup
    refute_same orig.args, copy.args
  end

  def test_copies_do_not_share_underlying_args
    orig = BuildOptions.new []
    copy = orig.dup
    refute_same orig.args, copy.args
  end
end

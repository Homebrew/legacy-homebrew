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

  def test_implicit_options
    # --without-baz is not explicitly specified on the command line (i.e. args)
    # therefore --with-baz should be implicitly assumed:
    assert_includes @build.implicit_options, "--with-baz"
    # But all these should not be in the implict_options:
    refute_includes @build.implicit_options, "--without-baz"
    refute_includes @build.implicit_options, "--with-bar"
    refute_includes @build.implicit_options, "--without-bar"
    refute_includes @build.implicit_options, "--with-qux"
  end

  def test_opposite_of
    assert_equal Option.new("without-foo"), @build.opposite_of(Option.new("with-foo"))
    assert_equal Option.new("with-foo"), @build.opposite_of("without-foo")
    assert_equal Option.new("disable-spam"), @build.opposite_of(Option.new("enable-spam"))
    assert_equal Option.new("enable-beer"), @build.opposite_of("disable-beer")
  end

  def test_has_opposite_of?
    assert @build.has_opposite_of?("--without-foo")
    assert @build.has_opposite_of?(Option.new("--with-qux"))
    assert !@build.has_opposite_of?("--without-qux")
    assert !@build.has_opposite_of?("--without-nonexisting")
  end

  def test_actually_recognizes_implicit_options
    assert @build.has_opposite_of?("--with-baz")
  end

  def test_copies_do_not_share_underlying_options
    orig = BuildOptions.new []
    copy = orig.dup
    copy.add 'foo'
    assert_empty orig
    assert_equal 1, copy.count
  end

  def test_copies_do_not_share_underlying_args
    orig = BuildOptions.new []
    copy = orig.dup
    copy.args << Option.new('foo')
    assert_empty orig.args
    assert_equal 1, copy.args.count
  end
end

require 'testing_env'
require 'build_options'

class BuildOptionsTests < Test::Unit::TestCase
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
    assert @build.include?("with-foo")
    assert !@build.include?("with-qux")
    assert !@build.include?("--with-foo")
  end

  def test_with_without
    assert @build.with?("foo")
    assert @build.with?("bar")
    assert @build.with?("baz")
    assert @build.without?("qux")
  end

  def test_used_options
    assert @build.used_options.include?("--with-foo")
    assert @build.used_options.include?("--with-bar")
  end

  def test_unused_options
    assert @build.unused_options.include?("--without-baz")
  end

  def test_implicit_options
    # --without-baz is not explicitly specified on the command line (i.e. args)
    # therefore --with-baz should be implicitly assumed:
    assert @build.implicit_options.include?("--with-baz")
    # But all these should not be in the implict_options:
    assert !@build.implicit_options.include?("--without-baz")
    assert !@build.implicit_options.include?("--with-bar")
    assert !@build.implicit_options.include?("--without-bar")
    assert !@build.implicit_options.include?("--with-qux")
  end

  def test_opposite_of
    assert @build.opposite_of(Option.new("with-foo")) == Option.new("without-foo")
    assert @build.opposite_of("without-foo") == Option.new("with-foo")
    assert @build.opposite_of(Option.new("enable-spam")) == Option.new("disable-spam")
    assert @build.opposite_of("disable-beer") == Option.new("enable-beer")
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

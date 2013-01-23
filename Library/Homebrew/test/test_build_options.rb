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
end

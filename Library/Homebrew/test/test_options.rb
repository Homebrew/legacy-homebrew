require "testing_env"
require "options"

class OptionTests < Homebrew::TestCase
  def setup
    @option = Option.new("foo")
  end

  def test_to_s
    assert_equal "--foo", @option.to_s
  end

  def test_equality
    foo = Option.new("foo")
    bar = Option.new("bar")
    assert_equal foo, @option
    refute_equal bar, @option
    assert_eql @option, foo
    refute_eql @option, bar
  end

  def test_description
    assert_empty @option.description
    assert_equal "foo", Option.new("foo", "foo").description
  end

  def test_inspect
    assert_equal "#<Option: \"--foo\">", @option.inspect
  end
end

class DeprecatedOptionTests < Homebrew::TestCase
  def setup
    @deprecated_option = DeprecatedOption.new("foo", "bar")
  end

  def test_old
    assert_equal "foo", @deprecated_option.old
    assert_equal "--foo", @deprecated_option.old_flag
  end

  def test_current
    assert_equal "bar", @deprecated_option.current
    assert_equal "--bar", @deprecated_option.current_flag
  end

  def test_equality
    foobar = DeprecatedOption.new("foo", "bar")
    boofar = DeprecatedOption.new("boo", "far")
    assert_equal foobar, @deprecated_option
    refute_equal boofar, @deprecated_option
    assert_eql @deprecated_option, foobar
    refute_eql @deprecated_option, boofar
  end
end

class OptionsTests < Homebrew::TestCase
  def setup
    @options = Options.new
  end

  def test_no_duplicate_options
    @options << Option.new("foo")
    @options << Option.new("foo")
    assert_includes @options, "--foo"
    assert_equal 1, @options.count
  end

  def test_preserves_existing_member_when_pushing_duplicate
    a = Option.new("foo", "bar")
    b = Option.new("foo", "qux")
    @options << a << b
    assert_equal 1, @options.count
    assert_same a, @options.first
    assert_equal a.description, @options.first.description
  end

  def test_include
    @options << Option.new("foo")
    assert_includes @options, "--foo"
    assert_includes @options, "foo"
    assert_includes @options, Option.new("foo")
  end

  def test_union_returns_options
    assert_instance_of Options, @options + Options.new
  end

  def test_difference_returns_options
    assert_instance_of Options, @options - Options.new
  end

  def test_shovel_returns_self
    assert_same @options, @options << Option.new("foo")
  end

  def test_as_flags
    @options << Option.new("foo")
    assert_equal %w[--foo], @options.as_flags
  end

  def test_to_a
    option = Option.new("foo")
    @options << option
    assert_equal [option], @options.to_a
  end

  def test_to_ary
    option = Option.new("foo")
    @options << option
    assert_equal [option], @options.to_ary
  end

  def test_intersection
    foo, bar, baz = %w[foo bar baz].map { |o| Option.new(o) }
    options = Options.new << foo << bar
    @options << foo << baz
    assert_equal [foo], (@options & options).to_a
  end

  def test_set_union
    foo, bar, baz = %w[foo bar baz].map { |o| Option.new(o) }
    options = Options.new << foo << bar
    @options << foo << baz
    assert_equal [foo, bar, baz].sort, (@options | options).sort
  end

  def test_times
    @options << Option.new("aa") << Option.new("bb") << Option.new("cc")
    assert_equal %w[--aa --bb --cc], (@options * "XX").split("XX").sort
  end

  def test_create_with_array
    array = %w[--foo --bar]
    option1 = Option.new("foo")
    option2 = Option.new("bar")
    assert_equal [option1, option2].sort, Options.create(array).sort
  end

  def test_inspect
    assert_equal "#<Options: []>", @options.inspect
    @options << Option.new("foo")
    assert_equal "#<Options: [#<Option: \"--foo\">]>", @options.inspect
  end
end

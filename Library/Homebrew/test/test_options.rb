require 'testing_env'
require 'options'

class OptionTests < Test::Unit::TestCase
  def setup
    @option = Option.new("foo")
  end

  def test_to_s
    assert_equal "--foo", @option.to_s
  end

  def test_to_str
    assert_equal "--foo", @option.to_str
  end

  def test_equality
    foo = Option.new("foo")
    bar = Option.new("bar")
    assert_equal foo, @option
    assert_not_equal bar, @option
    assert @option.eql?(foo)
    assert !@option.eql?(bar)
    assert bar < foo
  end

  def test_strips_leading_dashes
    option = Option.new("--foo")
    assert_equal "foo", option.name
    assert_equal "--foo", option.flag
  end

  def test_description
    assert_empty @option.description
    assert_equal "foo", Option.new("foo", "foo").description
  end

  def test_preserves_short_options
    option = Option.new("-d")
    assert_equal "-d", option.flag
    assert_equal "d", option.name
  end
end

class OptionsTests < Test::Unit::TestCase
  def setup
    @options = Options.new
  end

  def test_no_duplicate_options
    @options << Option.new("foo")
    @options << Option.new("foo")
    assert @options.include? "--foo"
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
    assert @options.include? "--foo"
    assert @options.include? "foo"
    assert @options.include? Option.new("foo")
  end

  def test_union_returns_options
    assert_instance_of Options, (@options + Options.new)
  end

  def test_difference_returns_options
    assert_instance_of Options, (@options - Options.new)
  end

  def test_shovel_returns_self
    assert_same @options, (@options << Option.new("foo"))
  end

  def test_as_flags
    @options << Option.new("foo")
    assert_equal %w{--foo}, @options.as_flags
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

  def test_concat_array
    option = Option.new("foo")
    @options.concat([option])
    assert @options.include?(option)
    assert_equal [option], @options.to_a
  end

  def test_concat_options
    option = Option.new("foo")
    opts = Options.new
    opts << option
    @options.concat(opts)
    assert @options.include?(option)
    assert_equal [option], @options.to_a
  end

  def test_concat_returns_self
    assert_same @options, (@options.concat([]))
  end

  def test_intersection
    foo, bar, baz = %w{foo bar baz}.map { |o| Option.new(o) }
    options = Options.new << foo << bar
    @options << foo << baz
    assert_equal [foo], (@options & options).to_a
  end

  def test_coerce_with_options
    assert_same @options, Options.coerce(@options)
  end

  def test_coerce_with_option
    option = Option.new("foo")
    assert_equal option, Options.coerce(option).to_a.first
  end

  def test_coerce_with_array
    array = %w{--foo --bar}
    option1 = Option.new("foo")
    option2 = Option.new("bar")
    assert_equal [option1, option2].sort, Options.coerce(array).to_a.sort
  end

  def test_coerce_raises_for_inappropriate_types
    assert_raises(TypeError) { Options.coerce(1) }
  end

  def test_coerce_splits_multiple_switches_with_single_dash
    array = %w{-vd}
    verbose = Option.new("-v")
    debug = Option.new("-d")
    assert_equal [verbose, debug].sort, Options.coerce(array).to_a.sort
  end
end

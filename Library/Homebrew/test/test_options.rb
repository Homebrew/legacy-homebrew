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

  def test_to_json
    assert_equal %q{"--foo"}, @option.to_json
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
end

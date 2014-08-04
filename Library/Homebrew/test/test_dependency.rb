require 'testing_env'
require 'dependency'

class DependableTests < Homebrew::TestCase
  def setup
    @tags = ["foo", "bar", :build]
    @dep = Struct.new(:tags).new(@tags).extend(Dependable)
  end

  def test_options
    assert_equal %w{--foo --bar}.sort, @dep.options.as_flags.sort
  end

  def test_interrogation
    assert_predicate @dep, :build?
    refute_predicate @dep, :optional?
    refute_predicate @dep, :recommended?
  end
end

class DependencyTests < Homebrew::TestCase
  def test_accepts_single_tag
    dep = Dependency.new("foo", %w{bar})
    assert_equal %w{bar}, dep.tags
  end

  def test_accepts_multiple_tags
    dep = Dependency.new("foo", %w{bar baz})
    assert_equal %w{bar baz}.sort, dep.tags.sort
  end

  def test_preserves_symbol_tags
    dep = Dependency.new("foo", [:build])
    assert_equal [:build], dep.tags
  end

  def test_accepts_symbol_and_string_tags
    dep = Dependency.new("foo", [:build, "bar"])
    assert_equal [:build, "bar"], dep.tags
  end

  def test_equality
    foo1 = Dependency.new("foo")
    foo2 = Dependency.new("foo")
    bar = Dependency.new("bar")
    assert_equal foo1, foo2
    assert_eql foo1, foo2
    refute_equal foo1, bar
    refute_eql foo1, bar
  end
end

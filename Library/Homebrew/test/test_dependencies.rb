require 'testing_env'
require 'dependencies'
require 'dependency'

class DependenciesTests < Test::Unit::TestCase
  def setup
    @deps = Dependencies.new
  end

  def test_shovel_returns_self
    assert_same @deps, (@deps << Dependency.new("foo"))
  end

  def test_no_duplicate_deps
    @deps << Dependency.new("foo")
    @deps << Dependency.new("foo", :build)
    @deps << Dependency.new("foo", :build)
    assert_equal 1, @deps.count
  end

  def test_preserves_order
    hash = { 0 => "foo", 1 => "bar", 2 => "baz" }
    @deps << Dependency.new(hash[0])
    @deps << Dependency.new(hash[1])
    @deps << Dependency.new(hash[2])
    @deps.each_with_index do |dep, idx|
      assert_equal hash[idx], dep.name
    end
  end

  def test_repetition
    @deps << Dependency.new("foo")
    @deps << Dependency.new("bar")
    assert_equal %q{foo, bar}, @deps*', '
  end

  def test_to_a
    dep = Dependency.new("foo")
    @deps << dep
    assert_equal [dep], @deps.to_a
  end

  def test_to_ary
    dep = Dependency.new("foo")
    @deps << dep
    assert_equal [dep], @deps.to_ary
  end
end

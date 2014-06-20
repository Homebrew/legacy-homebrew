require 'testing_env'
require 'dependencies'
require 'dependency'

class DependenciesTests < Homebrew::TestCase
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

  def test_type_helpers
    foo = Dependency.new("foo")
    bar = Dependency.new("bar", [:optional])
    baz = Dependency.new("baz", [:build])
    qux = Dependency.new("qux", [:recommended])
    quux = Dependency.new("quux")
    @deps << foo << bar << baz << qux << quux
    assert_equal [foo, quux], @deps.required
    assert_equal [bar], @deps.optional
    assert_equal [baz], @deps.build
    assert_equal [qux], @deps.recommended
    assert_equal [foo, baz, quux, qux].sort_by(&:name), @deps.default.sort_by(&:name)
  end

  def test_equality
    a = Dependencies.new
    b = Dependencies.new

    dep = Dependency.new("foo")

    a << dep
    b << dep

    assert_equal a, b
    assert a.eql?(b)

    b << Dependency.new("bar", [:optional])

    refute_equal a, b
    assert !a.eql?(b)
  end
end

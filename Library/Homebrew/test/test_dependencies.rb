require 'testing_env'
require 'test/testball'
require 'dependencies'

module DependencyCollectorTestExtension
  def find_dependency(name)
    deps.find { |dep| dep.name == name }
  end
end

class DependencyCollectorTests < Test::Unit::TestCase
  def setup
    @d = DependencyCollector.new.extend(DependencyCollectorTestExtension)
  end

  def test_dependency_creation
    @d.add 'foo' => :build
    @d.add 'bar' => ['--universal', :optional]
    assert_not_nil @d.find_dependency('foo')
    assert_equal 2, @d.find_dependency('bar').tags.length
  end

  def test_dependency_tags
    assert Dependency.new('foo', :build).build?
    assert Dependency.new('foo', [:build, :optional]).optional?
    assert Dependency.new('foo', [:universal]).options.include? '--universal'
    assert_empty Dependency.new('foo').tags
  end

  def test_no_duplicate_dependencies
    @d.add 'foo'
    @d.add 'foo' => :build
    assert_equal 1, @d.deps.count
    assert_empty @d.find_dependency('foo').tags
  end
end

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

  def test_to_ary
    assert_instance_of Array, @deps.to_ary
  end
end

class DependableTests < Test::Unit::TestCase
  def setup
    @tags = ["foo", "bar", :build]
    @dep = Struct.new(:tags).new(@tags).extend(Dependable)
  end

  def test_options
    assert_equal %w{--foo --bar}.sort, @dep.options.sort
  end

  def test_interrogation
    assert @dep.build?
    assert !@dep.optional?
    assert !@dep.recommended?
  end
end

class DependencyTests < Test::Unit::TestCase
  def test_accepts_single_tag
    dep = Dependency.new("foo", "bar")
    assert_equal %w{bar}, dep.tags
  end

  def test_accepts_multiple_tags
    dep = Dependency.new("foo", %w{bar baz})
    assert_equal %w{bar baz}.sort, dep.tags.sort
  end

  def test_preserves_symbol_tags
    dep = Dependency.new("foo", :build)
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
    assert foo1.eql?(foo2)
    assert_not_equal foo1, bar
    assert !foo1.eql?(bar)
  end
end

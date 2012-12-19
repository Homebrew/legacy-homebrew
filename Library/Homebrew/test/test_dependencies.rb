require 'testing_env'
require 'test/testball'
require 'dependencies'

class DependencyCollector
  def find_dependency(name)
    deps.find { |dep| dep.name == name }
  end
end

class DependencyTests < Test::Unit::TestCase
  def setup
    @d = DependencyCollector.new
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
    assert_equal 1, @d.deps.length
    assert_empty @d.find_dependency('foo').tags
  end
end

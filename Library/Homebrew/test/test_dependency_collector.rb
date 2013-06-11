require 'testing_env'
require 'dependency_collector'
require 'extend/set'

module DependencyCollectorTestExtension
  def find_dependency(name)
    deps.find { |dep| dep.name == name }
  end

  def find_requirement(klass)
    requirements.find { |req| klass === req }
  end
end

class DependencyCollectorTests < Test::Unit::TestCase
  def setup
    @d = DependencyCollector.new.extend(DependencyCollectorTestExtension)
  end

  def test_dependency_creation
    @d.add 'foo' => :build
    @d.add 'bar' => ['--universal', :optional]
    assert_instance_of Dependency, @d.find_dependency('foo')
    assert_equal 2, @d.find_dependency('bar').tags.length
  end

  def test_add_returns_created_dep
    ret = @d.add 'foo'
    assert_equal Dependency.new('foo'), ret
  end

  def test_dependency_tags
    assert Dependency.new('foo', [:build]).build?
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

  def test_requirement_creation
    @d.add :x11
    assert_instance_of X11Dependency, @d.find_requirement(X11Dependency)
  end

  def test_no_duplicate_requirements
    2.times { @d.add :x11 }
    assert_equal 1, @d.requirements.length
  end

  def test_requirement_tags
    @d.add :x11 => '2.5.1'
    @d.add :xcode => :build
    assert_empty @d.find_requirement(X11Dependency).tags
    assert @d.find_requirement(XcodeDependency).build?
  end

  def test_x11_no_tag
    @d.add :x11
    assert_empty @d.find_requirement(X11Dependency).tags
  end

  def test_x11_min_version
    @d.add :x11 => '2.5.1'
    assert_equal '2.5.1', @d.find_requirement(X11Dependency).min_version
  end

  def test_x11_tag
    @d.add :x11 => :optional
    assert @d.find_requirement(X11Dependency).optional?
  end

  def test_x11_min_version_and_tag
    @d.add :x11 => ['2.5.1', :optional]
    dep = @d.find_requirement(X11Dependency)
    assert_equal '2.5.1', dep.min_version
    assert dep.optional?
  end

  def test_libltdl_not_build_dep
    MacOS::Xcode.stubs(:provides_autotools?).returns(false)
    dep = @d.build(:libltdl)
    assert_equal Dependency.new("libtool"), dep
    assert !dep.build?
  end

  def test_autotools_dep_no_system_autotools
    MacOS::Xcode.stubs(:provides_autotools?).returns(false)
    dep = @d.build(:libtool)
    assert_equal Dependency.new("libtool"), dep
    assert dep.build?
  end

  def test_autotools_dep_system_autotools
    MacOS::Xcode.stubs(:provides_autotools?).returns(true)
    assert_nil @d.build(:libtool)
  end

  def test_x11_proxy_dep_mountain_lion
    MacOS.stubs(:version).returns(MacOS::Version.new(10.8))
    assert_equal Dependency.new("libpng"), @d.build(:libpng)
  end

  def test_x11_proxy_dep_lion_or_older
    MacOS.stubs(:version).returns(MacOS::Version.new(10.7))
    assert_equal X11Dependency::Proxy.new(:libpng), @d.build(:libpng)
  end

  def test_ld64_dep_pre_leopard
    MacOS.stubs(:version).returns(MacOS::Version.new(10.4))
    assert_equal LD64Dependency.new, @d.build(:ld64)
  end

  def test_ld64_dep_leopard_or_newer
    MacOS.stubs(:version).returns(MacOS::Version.new(10.5))
    assert_nil @d.build(:ld64)
  end

  def test_raises_typeerror_for_unknown_classes
    assert_raises(TypeError) { @d.add(Class.new) }
  end

  def test_raises_typeerror_for_unknown_types
    assert_raises(TypeError) { @d.add(Object.new) }
  end
end

require "testing_env"
require "dependency_collector"

class DependencyCollectorTests < Homebrew::TestCase
  def find_dependency(name)
    @d.deps.find { |dep| dep.name == name }
  end

  def find_requirement(klass)
    @d.requirements.find { |req| klass === req }
  end

  def setup
    @d = DependencyCollector.new
  end

  def teardown
    DependencyCollector.clear_cache
  end

  def test_dependency_creation
    @d.add "foo" => :build
    @d.add "bar" => ["--universal", :optional]
    assert_instance_of Dependency, find_dependency("foo")
    assert_equal 2, find_dependency("bar").tags.length
  end

  def test_add_returns_created_dep
    ret = @d.add "foo"
    assert_equal Dependency.new("foo"), ret
  end

  def test_dependency_tags
    assert_predicate Dependency.new("foo", [:build]), :build?
    assert_predicate Dependency.new("foo", [:build, :optional]), :optional?
    assert_includes Dependency.new("foo", ["universal"]).options, "--universal"
    assert_empty Dependency.new("foo").tags
  end

  def test_requirement_creation
    @d.add :x11
    assert_instance_of X11Requirement, find_requirement(X11Requirement)
  end

  def test_no_duplicate_requirements
    2.times { @d.add :x11 }
    assert_equal 1, @d.requirements.count
  end

  def test_requirement_tags
    @d.add :x11 => "2.5.1"
    @d.add :xcode => :build
    assert_empty find_requirement(X11Requirement).tags
    assert_predicate find_requirement(XcodeRequirement), :build?
  end

  def test_x11_no_tag
    @d.add :x11
    assert_empty find_requirement(X11Requirement).tags
  end

  def test_x11_min_version
    @d.add :x11 => "2.5.1"
    assert_equal "2.5.1", find_requirement(X11Requirement).min_version.to_s
  end

  def test_x11_tag
    @d.add :x11 => :optional
    assert_predicate find_requirement(X11Requirement), :optional?
  end

  def test_x11_min_version_and_tag
    @d.add :x11 => ["2.5.1", :optional]
    dep = find_requirement(X11Requirement)
    assert_equal "2.5.1", dep.min_version.to_s
    assert_predicate dep, :optional?
  end

  def test_ld64_dep_pre_leopard
    MacOS.stubs(:version).returns(MacOS::Version.new("10.4"))
    assert_equal LD64Dependency.new, @d.build(:ld64)
  end

  def test_ld64_dep_leopard_or_newer
    MacOS.stubs(:version).returns(MacOS::Version.new("10.5"))
    assert_nil @d.build(:ld64)
  end

  def test_raises_typeerror_for_unknown_classes
    assert_raises(TypeError) { @d.add(Class.new) }
  end

  def test_raises_typeerror_for_unknown_types
    assert_raises(TypeError) { @d.add(Object.new) }
  end

  def test_does_not_mutate_dependency_spec
    spec = { "foo" => :optional }
    copy = spec.dup
    @d.add(spec)
    assert_equal copy, spec
  end

  def test_resource_dep_git_url
    resource = Resource.new
    resource.url("git://example.com/foo/bar.git")
    assert_instance_of GitRequirement, @d.add(resource)
  end

  def test_resource_dep_gzip_url
    resource = Resource.new
    resource.url("http://example.com/foo.tar.gz")
    assert_nil @d.add(resource)
  end

  def test_resource_dep_xz_url
    resource = Resource.new
    resource.url("http://example.com/foo.tar.xz")
    assert_equal Dependency.new("xz", [:build]), @d.add(resource)
  end

  def test_resource_dep_raises_for_unknown_classes
    resource = Resource.new
    resource.download_strategy = Class.new
    assert_raises(TypeError) { @d.add(resource) }
  end
end

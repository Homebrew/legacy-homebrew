require 'testing_env'
require 'test/testball'

class FormulaTests < Homebrew::TestCase
  def test_formula_instantiation
    klass = Class.new(Formula) { url "http://example.com/foo-1.0.tar.gz" }
    name = "formula_name"
    path = Formula.path(name)
    spec = :stable

    f = klass.new(name, path, spec)
    assert_equal name, f.name
    assert_equal path, f.path
    assert_raises(ArgumentError) { klass.new }
  end

  def test_prefix
    f = TestBall.new
    assert_equal HOMEBREW_CELLAR/f.name/'0.1', f.prefix
    assert_kind_of Pathname, f.prefix
  end

  def test_revised_prefix
    f = Class.new(TestBall) { revision 1 }.new
    assert_equal HOMEBREW_CELLAR/f.name/'0.1_1', f.prefix
  end

  def test_installed?
    f = TestBall.new
    f.stubs(:installed_prefix).returns(stub(:directory? => false))
    refute_predicate f, :installed?

    f.stubs(:installed_prefix).returns(
      stub(:directory? => true, :children => [])
    )
    refute_predicate f, :installed?

    f.stubs(:installed_prefix).returns(
      stub(:directory? => true, :children => [stub])
    )
    assert_predicate f, :installed?
  end

  def test_installed_prefix
    f = Class.new(TestBall).new
    assert_equal f.prefix, f.installed_prefix
  end

  def test_installed_prefix_head_installed
    f = formula do
      head 'foo'
      devel do
        url 'foo'
        version '1.0'
      end
    end
    prefix = HOMEBREW_CELLAR+f.name+f.head.version
    prefix.mkpath
    assert_equal prefix, f.installed_prefix
  ensure
    f.rack.rmtree
  end

  def test_installed_prefix_devel_installed
    f = formula do
      head 'foo'
      devel do
        url 'foo'
        version '1.0'
      end
    end
    prefix = HOMEBREW_CELLAR+f.name+f.devel.version
    prefix.mkpath
    assert_equal prefix, f.installed_prefix
  ensure
    f.rack.rmtree
  end

  def test_installed_prefix_stable_installed
    f = formula do
      head 'foo'
      devel do
        url 'foo'
        version '1.0-devel'
      end
    end
    prefix = HOMEBREW_CELLAR+f.name+f.version
    prefix.mkpath
    assert_equal prefix, f.installed_prefix
  ensure
    f.rack.rmtree
  end

  def test_installed_prefix_head_active_spec
    f = formula("test", Pathname.new(__FILE__).expand_path, :head) do
      head 'foo'
      devel do
        url 'foo'
        version '1.0-devel'
      end
    end
    prefix = HOMEBREW_CELLAR+f.name+f.head.version
    assert_equal prefix, f.installed_prefix
  end

  def test_installed_prefix_devel_active_spec
    f = formula("test", Pathname.new(__FILE__).expand_path, :devel) do
      head 'foo'
      devel do
        url 'foo'
        version '1.0-devel'
      end
    end
    prefix = HOMEBREW_CELLAR+f.name+f.devel.version
    assert_equal prefix, f.installed_prefix
  end

  def test_equality
    x = TestBall.new
    y = TestBall.new
    assert_equal x, y
    assert_eql x, y
    assert_equal x.hash, y.hash
  end

  def test_inequality
    x = TestBall.new("foo")
    y = TestBall.new("bar")
    refute_equal x, y
    refute_eql x, y
    refute_equal x.hash, y.hash
  end

  def test_comparison_with_non_formula_objects_does_not_raise
    refute_equal TestBall.new, Object.new
  end

  def test_sort_operator
    assert_nil TestBall.new <=> Object.new
  end

  def test_class_naming
    assert_equal 'ShellFm', Formulary.class_s('shell.fm')
    assert_equal 'Fooxx', Formulary.class_s('foo++')
    assert_equal 'SLang', Formulary.class_s('s-lang')
    assert_equal 'PkgConfig', Formulary.class_s('pkg-config')
    assert_equal 'FooBar', Formulary.class_s('foo_bar')
  end

  def test_formula_spec_integration
    f = Class.new(Formula) do
      homepage 'http://example.com'
      url 'http://example.com/test-0.1.tbz'
      mirror 'http://example.org/test-0.1.tbz'
      sha1 TEST_SHA1

      head 'http://example.com/test.git', :tag => 'foo'

      devel do
        url 'http://example.com/test-0.2.tbz'
        mirror 'http://example.org/test-0.2.tbz'
        sha256 TEST_SHA256
      end

      bottle { sha1 TEST_SHA1 => bottle_tag }

      def initialize
        super "test", Pathname.new(__FILE__).expand_path, :stable
      end
    end.new

    assert_equal 'http://example.com', f.homepage
    assert_version_equal '0.1', f.version
    assert_equal f.stable, f.active_spec

    assert_instance_of SoftwareSpec, f.stable
    assert_instance_of SoftwareSpec, f.devel
    assert_instance_of HeadSoftwareSpec, f.head
  end

  def test_path
    name = 'foo-bar'
    assert_equal Pathname.new("#{HOMEBREW_LIBRARY}/Formula/#{name}.rb"), Formula.path(name)
  end

  def test_factory
    name = 'foo-bar'
    path = HOMEBREW_PREFIX+"Library/Formula/#{name}.rb"
    path.dirname.mkpath
    File.open(path, 'w') do |f|
      f << %{
        require 'formula'
        class #{Formulary.class_s(name)} < Formula
          url 'foo-1.0'
        end
      }
    end
    assert_kind_of Formula, Formulary.factory(name)
  ensure
    path.unlink
  end

  def test_class_specs_are_always_initialized
    f = formula { url 'foo-1.0' }

    %w{stable devel head}.each do |spec|
      assert_kind_of SoftwareSpec, f.class.send(spec)
    end
  end

  def test_incomplete_instance_specs_are_not_accessible
    f = formula { url 'foo-1.0' }

    %w{devel head}.each { |spec| assert_nil f.send(spec) }
  end

  def test_honors_attributes_declared_before_specs
    f = formula do
      url 'foo-1.0'
      depends_on 'foo'
      devel { url 'foo-1.1' }
    end

    %w{stable devel head}.each do |spec|
      assert_equal 'foo', f.class.send(spec).deps.first.name
    end
  end

  def test_simple_version
    assert_equal PkgVersion.parse('1.0'), formula { url 'foo-1.0.bar' }.pkg_version
  end

  def test_version_with_revision
    f = formula do
      url 'foo-1.0.bar'
      revision 1
    end

    assert_equal PkgVersion.parse('1.0_1'), f.pkg_version
  end

  def test_head_ignores_revisions
    f = formula("test", Pathname.new(__FILE__).expand_path, :head) do
      url 'foo-1.0.bar'
      revision 1
      head 'foo'
    end

    assert_equal PkgVersion.parse('HEAD'), f.pkg_version
  end

  def test_raises_when_non_formula_constant_exists
    const = :SomeConst
    Object.const_set(const, Module.new)
    begin
      assert_raises(FormulaUnavailableError) { Formulary.factory("some_const") }
    ensure
      Object.send(:remove_const, const)
    end
  end
end

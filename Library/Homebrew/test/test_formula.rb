require 'testing_env'
require 'test/testball'

class FormulaTests < Test::Unit::TestCase
  include VersionAssertions

  def test_prefix
    f = TestBall.new
    assert_equal File.expand_path(f.prefix), (HOMEBREW_CELLAR+f.name+'0.1').to_s
    assert_kind_of Pathname, f.prefix
  end

  def test_installed?
    f = TestBall.new
    f.stubs(:installed_prefix).returns(stub(:directory? => false))
    assert !f.installed?

    f.stubs(:installed_prefix).returns(
      stub(:directory? => true, :children => [])
    )
    assert !f.installed?

    f.stubs(:installed_prefix).returns(
      stub(:directory? => true, :children => [stub])
    )
    assert f.installed?
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
    prefix.rmtree
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
    prefix.rmtree
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
    prefix.rmtree
  end

  def test_installed_prefix_head_active_spec
    ARGV.stubs(:build_head? => true)

    f = formula do
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
    ARGV.stubs(:build_devel? => true)

    f = formula do
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
    assert x == y
    assert y == x
    assert x.eql?(y)
    assert y.eql?(x)
    assert x.hash == y.hash
  end

  def test_inequality
    x = TestBall.new("foo")
    y = TestBall.new("bar")
    assert x != y
    assert y != x
    assert x.hash != y.hash
    assert !x.eql?(y)
    assert !y.eql?(x)
  end

  def test_class_naming
    assert_equal 'ShellFm', Formula.class_s('shell.fm')
    assert_equal 'Fooxx', Formula.class_s('foo++')
    assert_equal 'SLang', Formula.class_s('s-lang')
    assert_equal 'PkgConfig', Formula.class_s('pkg-config')
    assert_equal 'FooBar', Formula.class_s('foo_bar')
  end

  def test_mirror_support
    f = Class.new(Formula) do
      url "file:///#{TEST_FOLDER}/bad_url/testball-0.1.tbz"
      mirror "file:///#{TEST_FOLDER}/tarballs/testball-0.1.tbz"
    end.new("test_mirror_support")

    shutup { f.fetch }

    assert_equal "file:///#{TEST_FOLDER}/bad_url/testball-0.1.tbz", f.url
    assert_equal "file:///#{TEST_FOLDER}/tarballs/testball-0.1.tbz",
      f.downloader.instance_variable_get(:@url)
  end

  def test_formula_spec_integration
    f = Class.new(Formula) do
      homepage 'http://example.com'
      url 'file:///foo.com/testball-0.1.tbz'
      mirror 'file:///foo.org/testball-0.1.tbz'
      sha1 '482e737739d946b7c8cbaf127d9ee9c148b999f5'

      head 'https://github.com/mxcl/homebrew.git', :tag => 'foo'

      devel do
        url 'file:///foo.com/testball-0.2.tbz'
        mirror 'file:///foo.org/testball-0.2.tbz'
        sha256 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef'
      end

      bottle do
        sha1 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeef' => :snow_leopard_32
        sha1 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeef' => :snow_leopard
        sha1 'baadf00dbaadf00dbaadf00dbaadf00dbaadf00d' => :lion
        sha1 '8badf00d8badf00d8badf00d8badf00d8badf00d' => :mountain_lion
      end

      def initialize(name="spec_test_ball", path=nil)
        super
      end
    end.new

    assert_equal 'http://example.com', f.homepage
    assert_version_equal '0.1', f.version
    assert_equal f.stable, f.active_spec
    assert_instance_of CurlDownloadStrategy, f.downloader

    assert_instance_of SoftwareSpec, f.stable
    assert_instance_of Bottle, f.bottle
    assert_instance_of SoftwareSpec, f.devel
    assert_instance_of HeadSoftwareSpec, f.head
  end

  def test_path
    name = 'foo-bar'
    assert_equal Pathname.new("#{HOMEBREW_REPOSITORY}/Library/Formula/#{name}.rb"), Formula.path(name)
  end

  def test_factory
    name = 'foo-bar'
    path = HOMEBREW_PREFIX+"Library/Formula/#{name}.rb"
    path.dirname.mkpath
    File.open(path, 'w') do |f|
      f << %{
        require 'formula'
        class #{Formula.class_s(name)} < Formula
          url 'foo-1.0'
          def initialize(*args)
            @homepage = 'http://example.com/'
            super
          end
        end
      }
    end
    assert_kind_of Formula, Formula.factory(name)
  ensure
    path.unlink
  end

  def test_dependency_option_integration
    f = formula do
      url 'foo-1.0'
      depends_on 'foo' => :optional
      depends_on 'bar' => :recommended
    end

    assert f.build.has_option?('with-foo')
    assert f.build.has_option?('without-bar')
  end

  def test_explicit_options_override_default_dep_option_description
    f = formula do
      url 'foo-1.0'
      option 'with-foo', 'blah'
      depends_on 'foo' => :optional
    end

    assert_equal 'blah', f.build.first.description
  end
end

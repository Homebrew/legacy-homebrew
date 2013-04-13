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

  def test_formula_specs
    f = SpecTestBall.new

    assert_equal 'http://example.com', f.homepage
    assert_equal 'file:///foo.com/testball-0.1.tbz', f.url
    assert_equal 1, f.mirrors.length
    assert_version_equal '0.1', f.version
    assert_equal f.stable, f.active_spec
    assert_equal CurlDownloadStrategy, f.download_strategy
    assert_instance_of CurlDownloadStrategy, f.downloader

    assert_instance_of SoftwareSpec, f.stable
    assert_instance_of Bottle, f.bottle
    assert_instance_of SoftwareSpec, f.devel
    assert_instance_of HeadSoftwareSpec, f.head

    assert_equal 'file:///foo.com/testball-0.1.tbz', f.stable.url
    assert_equal "https://downloads.sf.net/project/machomebrew/Bottles/spec_test_ball-0.1.#{MacOS.cat}.bottle.tar.gz",
      f.bottle.url
    assert_equal 'file:///foo.com/testball-0.2.tbz', f.devel.url
    assert_equal 'https://github.com/mxcl/homebrew.git', f.head.url

    assert_empty f.stable.specs
    assert_empty f.bottle.specs
    assert_empty f.devel.specs
    assert_equal({ :tag => 'foo' }, f.head.specs)

    assert_equal CurlDownloadStrategy, f.stable.download_strategy
    assert_equal CurlBottleDownloadStrategy, f.bottle.download_strategy
    assert_equal CurlDownloadStrategy, f.devel.download_strategy
    assert_equal GitDownloadStrategy, f.head.download_strategy

    assert_instance_of Checksum, f.stable.checksum
    assert_instance_of Checksum, f.bottle.checksum
    assert_instance_of Checksum, f.devel.checksum
    assert !f.stable.checksum.empty?
    assert !f.bottle.checksum.empty?
    assert !f.devel.checksum.empty?
    assert_nil f.head.checksum
    assert_equal :sha1, f.stable.checksum.hash_type
    assert_equal :sha1, f.bottle.checksum.hash_type
    assert_equal :sha256, f.devel.checksum.hash_type
    assert_equal case MacOS.cat
      when :snow_leopard_32 then 'deadbeef'*5
      when :snow_leopard    then 'faceb00c'*5
      when :lion            then 'baadf00d'*5
      when :mountain_lion   then '8badf00d'*5
      end, f.bottle.checksum.hexdigest
    assert_match(/[0-9a-fA-F]{40}/, f.stable.checksum.hexdigest)
    assert_match(/[0-9a-fA-F]{64}/, f.devel.checksum.hexdigest)

    assert_equal 1, f.stable.mirrors.length
    assert f.bottle.mirrors.empty?
    assert_equal 1, f.devel.mirrors.length
    assert f.head.mirrors.empty?

    assert f.stable.version.detected_from_url?
    assert f.bottle.version.detected_from_url?
    assert f.devel.version.detected_from_url?
    assert_version_equal '0.1', f.stable.version
    assert_version_equal '0.1', f.bottle.version
    assert_version_equal '0.2', f.devel.version
    assert_version_equal 'HEAD', f.head.version
    assert_equal 0, f.bottle.revision
  end

  def test_devel_active_spec
    ARGV << '--devel'
    f = SpecTestBall.new
    assert_equal f.devel, f.active_spec
    assert_version_equal '0.2', f.version
    assert_equal 'file:///foo.com/testball-0.2.tbz', f.url
    assert_equal CurlDownloadStrategy, f.download_strategy
    assert_instance_of CurlDownloadStrategy, f.downloader
  ensure
    ARGV.delete '--devel'
  end

  def test_head_active_spec
    ARGV << '--HEAD'
    f = SpecTestBall.new
    assert_equal f.head, f.active_spec
    assert_version_equal 'HEAD', f.version
    assert_equal 'https://github.com/mxcl/homebrew.git', f.url
    assert_equal GitDownloadStrategy, f.download_strategy
    assert_instance_of GitDownloadStrategy, f.downloader
  ensure
    ARGV.delete '--HEAD'
  end

  def test_explicit_version_spec
    f = ExplicitVersionSpecTestBall.new
    assert_version_equal '0.3', f.version
    assert_version_equal '0.3', f.stable.version
    assert_version_equal '0.4', f.devel.version
    assert !f.stable.version.detected_from_url?
    assert !f.devel.version.detected_from_url?
  end

  def test_head_only_specs
    f = HeadOnlySpecTestBall.new

    assert_nil f.stable
    assert_nil f.bottle
    assert_nil f.devel

    assert_equal f.head, f.active_spec
    assert_version_equal 'HEAD', f.version
    assert_nil f.head.checksum
    assert_equal 'https://github.com/mxcl/homebrew.git', f.url
    assert_equal GitDownloadStrategy, f.download_strategy
    assert_instance_of GitDownloadStrategy, f.downloader
    assert_instance_of HeadSoftwareSpec, f.head
  end

  def test_incomplete_stable_specs
    f = IncompleteStableSpecTestBall.new

    assert_nil f.stable
    assert_nil f.bottle
    assert_nil f.devel

    assert_equal f.head, f.active_spec
    assert_version_equal 'HEAD', f.version
    assert_nil f.head.checksum
    assert_equal 'https://github.com/mxcl/homebrew.git', f.url
    assert_equal GitDownloadStrategy, f.download_strategy
    assert_instance_of GitDownloadStrategy, f.downloader
    assert_instance_of HeadSoftwareSpec, f.head
  end

  def test_head_only_with_version_specs
    f = IncompleteStableSpecTestBall.new

    assert_nil f.stable
    assert_nil f.bottle
    assert_nil f.devel

    assert_equal f.head, f.active_spec
    assert_version_equal 'HEAD', f.version
    assert_nil f.head.checksum
    assert_equal 'https://github.com/mxcl/homebrew.git', f.url
    assert_equal GitDownloadStrategy, f.download_strategy
    assert_instance_of GitDownloadStrategy, f.downloader
    assert_instance_of HeadSoftwareSpec, f.head
  end

  def test_explicit_strategy_specs
    f = ExplicitStrategySpecTestBall.new

    assert_instance_of SoftwareSpec, f.stable
    assert_instance_of SoftwareSpec, f.devel
    assert_instance_of HeadSoftwareSpec, f.head

    assert_equal f.stable, f.active_spec

    assert_nil f.stable.checksum
    assert_nil f.devel.checksum
    assert_nil f.head.checksum

    assert_equal MercurialDownloadStrategy, f.stable.download_strategy
    assert_equal BazaarDownloadStrategy, f.devel.download_strategy
    assert_equal SubversionDownloadStrategy, f.head.download_strategy

    assert_equal({ :tag => '0.2' }, f.stable.specs)
    assert_equal({ :tag => '0.3' }, f.devel.specs)
    assert f.head.specs.empty?
  end

  def test_revised_bottle_specs
    f = RevisedBottleSpecTestBall.new

    assert_equal 1, f.bottle.revision
    assert_equal case MacOS.cat
      when :snow_leopard_32 then 'deadbeef'*5
      when :snow_leopard    then 'faceb00k'*5
      when :lion            then 'baadf00d'*5
      when :mountain_lion   then '8badf00d'*5
      end, f.bottle.checksum.hexdigest
  end

  def test_custom_version_scheme
    scheme = Class.new(Version)
    f = Class.new(TestBall) { version '1.0' => scheme }.new

    assert_version_equal '1.0', f.version
    assert_instance_of scheme, f.version
  end

  def test_formula_funcs
    foobar = 'foo-bar'
    path = Formula.path(foobar)

    assert_match Regexp.new("^#{HOMEBREW_PREFIX}/Library/Formula"),
      path.to_s

    path = HOMEBREW_PREFIX+"Library/Formula/#{foobar}.rb"
    path.dirname.mkpath
    File.open(path, 'w') do |f|
      f << %{
        require 'formula'
        class #{Formula.class_s(foobar)} < Formula
          url 'foo-1.0'
          def initialize(*args)
            @homepage = 'http://example.com/'
            super
          end
        end
      }
    end

    assert_not_nil Formula.factory(foobar)
  end
end

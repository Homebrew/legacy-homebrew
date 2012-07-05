require 'testing_env'
require 'test/testball'

class AbstractDownloadStrategy
  attr_reader :url
end

class MostlyAbstractFormula < Formula
  @url=''
  @homepage = 'http://example.com/'
end

class FormulaTests < Test::Unit::TestCase

  def test_prefix
    nostdout do
      TestBall.new.brew do |f|
        assert_equal File.expand_path(f.prefix), (HOMEBREW_CELLAR+f.name+'0.1').to_s
        assert_kind_of Pathname, f.prefix
      end
    end
  end

  def test_class_naming
    assert_equal 'ShellFm', Formula.class_s('shell.fm')
    assert_equal 'Fooxx', Formula.class_s('foo++')
    assert_equal 'SLang', Formula.class_s('s-lang')
    assert_equal 'PkgConfig', Formula.class_s('pkg-config')
    assert_equal 'FooBar', Formula.class_s('foo_bar')
  end

  def test_cant_override_brew
    assert_raises(RuntimeError) do
      eval <<-EOS
      class TestBallOverrideBrew < Formula
        def initialize
          super "foo"
        end
        def brew
        end
      end
      EOS
    end
  end

  def test_abstract_formula
    f=MostlyAbstractFormula.new
    assert_equal '__UNKNOWN__', f.name
    assert_raises(RuntimeError) { f.prefix }
    nostdout { assert_raises(RuntimeError) { f.brew } }
  end

  def test_mirror_support
    HOMEBREW_CACHE.mkpath unless HOMEBREW_CACHE.exist?
    nostdout do
      f = TestBallWithMirror.new
      tarball, downloader = f.fetch
      assert_equal f.url, "file:///#{TEST_FOLDER}/bad_url/testball-0.1.tbz"
      assert_equal downloader.url, "file:///#{TEST_FOLDER}/tarballs/testball-0.1.tbz"
    end
  end

  def test_formula_specs
    f = SpecTestBall.new

    assert_equal 'http://example.com', f.homepage
    assert_equal 'file:///foo.com/testball-0.1.tbz', f.url
    assert_equal 1, f.mirrors.length
    assert_equal '0.1', f.version
    assert_equal f.stable, f.active_spec
    assert_equal CurlDownloadStrategy, f.download_strategy
    assert_instance_of CurlDownloadStrategy, f.downloader

    assert_instance_of SoftwareSpec, f.stable
    assert_instance_of Bottle, f.bottle
    assert_instance_of SoftwareSpec, f.devel
    assert_instance_of HeadSoftwareSpec, f.head

    assert_equal 'file:///foo.com/testball-0.1.tbz', f.stable.url
    assert_equal "https://downloads.sf.net/project/machomebrew/Bottles/spectestball-0.1.#{MacOS.cat}.bottle.tar.gz",
      f.bottle.url
    assert_equal 'file:///foo.com/testball-0.2.tbz', f.devel.url
    assert_equal 'https://github.com/mxcl/homebrew.git', f.head.url

    assert_nil f.stable.specs
    assert_nil f.bottle.specs
    assert_nil f.devel.specs
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
      when :snowleopard then 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeef'
      when :lion then 'baadf00dbaadf00dbaadf00dbaadf00dbaadf00d'
      when :mountainlion then '8badf00d8badf00d8badf00d8badf00d8badf00d'
      end, f.bottle.checksum.hexdigest
    assert_match /[0-9a-fA-F]{40}/, f.stable.checksum.hexdigest
    assert_match /[0-9a-fA-F]{64}/, f.devel.checksum.hexdigest

    assert_nil f.stable.md5
    assert_nil f.stable.sha256
    assert_nil f.bottle.md5
    assert_nil f.bottle.sha256
    assert_nil f.devel.md5
    assert_nil f.devel.sha1

    assert_equal 1, f.stable.mirrors.length
    assert_nil f.bottle.mirrors
    assert_equal 1, f.devel.mirrors.length
    assert_nil f.head.mirrors

    assert !f.stable.explicit_version?
    assert !f.bottle.explicit_version?
    assert !f.devel.explicit_version?
    assert_equal '0.1', f.stable.version
    assert_equal '0.1', f.bottle.version
    assert_equal '0.2', f.devel.version
    assert_equal 'HEAD', f.head.version
    assert_equal 0, f.bottle.revision
  end

  def test_ancient_formula_specs
    f = AncientSpecTestBall.new

    assert_equal 'http://example.com', f.homepage
    assert_equal 'file:///foo.com/testball-0.1.tbz', f.url
    assert_equal '0.1', f.version
    assert_equal f.stable, f.active_spec
    assert_equal CurlDownloadStrategy, f.download_strategy
    assert_instance_of CurlDownloadStrategy, f.downloader

    assert_instance_of SoftwareSpec, f.stable
    assert_instance_of HeadSoftwareSpec, f.head

    assert_equal 'file:///foo.com/testball-0.1.tbz', f.stable.url
    assert_equal 'https://github.com/mxcl/homebrew.git', f.head.url

    assert_nil f.stable.specs
    assert_equal({ :tag => 'foo' }, f.head.specs)

    assert_instance_of Checksum, f.stable.checksum
    assert_nil f.head.checksum
    assert_equal :md5, f.stable.checksum.hash_type
    assert_match /[0-9a-fA-F]{32}/, f.stable.checksum.hexdigest

    assert !f.stable.explicit_version?
    assert_equal '0.1', f.stable.version
    assert_equal 'HEAD', f.head.version
  end

  def test_devel_active_spec
    ARGV.push '--devel'
    f = SpecTestBall.new
    assert_equal f.devel, f.active_spec
    assert_equal '0.2', f.version
    assert_equal 'file:///foo.com/testball-0.2.tbz', f.url
    assert_equal CurlDownloadStrategy, f.download_strategy
    assert_instance_of CurlDownloadStrategy, f.downloader
    ARGV.delete '--devel'
  end

  def test_head_active_spec
    ARGV.push '--HEAD'
    f = SpecTestBall.new
    assert_equal f.head, f.active_spec
    assert_equal 'HEAD', f.version
    assert_equal 'https://github.com/mxcl/homebrew.git', f.url
    assert_equal GitDownloadStrategy, f.download_strategy
    assert_instance_of GitDownloadStrategy, f.downloader
    ARGV.delete '--HEAD'
  end

  def test_explicit_version_spec
    f = ExplicitVersionSpecTestBall.new
    assert_equal '0.3', f.version
    assert_equal '0.3', f.stable.version
    assert_equal '0.4', f.devel.version
    assert f.stable.explicit_version?
    assert f.devel.explicit_version?
  end

  def test_old_bottle_specs
    f = OldBottleSpecTestBall.new

    case MacOS.cat
    when :lion
      assert_instance_of Bottle, f.bottle
      assert_equal CurlBottleDownloadStrategy, f.bottle.download_strategy
      assert_nil f.bottle.specs
      assert_nil f.bottle.mirrors

      assert_equal 'file:///foo.com/testball-0.1-bottle.tar.gz', f.bottle.url

      assert_instance_of Checksum, f.bottle.checksum
      assert_equal :sha1, f.bottle.checksum.hash_type
      assert !f.bottle.checksum.empty?
      assert_equal 'baadf00dbaadf00dbaadf00dbaadf00dbaadf00d', f.bottle.sha1.hexdigest
      assert_nil f.bottle.md5
      assert_nil f.bottle.sha256

      assert !f.bottle.explicit_version?
      assert_equal 0, f.bottle.revision
      assert_equal '0.1', f.bottle.version
    else
      assert_nil f.bottle
    end
  end

  def test_ancient_bottle_specs
    f = AncientBottleSpecTestBall.new
    assert_nil f.bottle
  end

  def test_head_only_specs
    f = HeadOnlySpecTestBall.new

    assert_not_nil f.head
    assert_nil f.stable
    assert_nil f.bottle
    assert_nil f.devel

    assert_equal f.head, f.active_spec
    assert_equal 'HEAD', f.version
    assert_nil f.head.checksum
    assert_equal 'https://github.com/mxcl/homebrew.git', f.url
    assert_equal GitDownloadStrategy, f.download_strategy
    assert_instance_of GitDownloadStrategy, f.downloader
    assert_instance_of HeadSoftwareSpec, f.head
  end

  def test_incomplete_stable_specs
    f = IncompleteStableSpecTestBall.new

    assert_not_nil f.head
    assert_nil f.stable
    assert_nil f.bottle
    assert_nil f.devel

    assert_equal f.head, f.active_spec
    assert_equal 'HEAD', f.version
    assert_nil f.head.checksum
    assert_equal 'https://github.com/mxcl/homebrew.git', f.url
    assert_equal GitDownloadStrategy, f.download_strategy
    assert_instance_of GitDownloadStrategy, f.downloader
    assert_instance_of HeadSoftwareSpec, f.head
  end

  def test_head_only_with_version_specs
    f = IncompleteStableSpecTestBall.new

    assert_not_nil f.head
    assert_nil f.stable
    assert_nil f.bottle
    assert_nil f.devel

    assert_equal f.head, f.active_spec
    assert_equal 'HEAD', f.version
    assert_nil f.head.checksum
    assert_equal 'https://github.com/mxcl/homebrew.git', f.url
    assert_equal GitDownloadStrategy, f.download_strategy
    assert_instance_of GitDownloadStrategy, f.downloader
    assert_instance_of HeadSoftwareSpec, f.head
  end

  def test_explicit_strategy_specs
    f = ExplicitStrategySpecTestBall.new

    assert_not_nil f.stable
    assert_not_nil f.devel
    assert_not_nil f.head

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
      when :snowleopard then 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeef'
      when :lion then 'baadf00dbaadf00dbaadf00dbaadf00dbaadf00d'
      when :mountainlion then '8badf00d8badf00d8badf00d8badf00d8badf00d'
      end, f.bottle.checksum.hexdigest
  end
end

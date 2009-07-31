#!/usr/bin/ruby
$:.unshift File.dirname(__FILE__)
require 'formula'
require 'keg'
require 'pathname+yeast'
require 'stringio'
require 'utils'

# these are defined in env.rb usually, but we don't want to break our actual
# homebrew tree, and we do want to test everything :)
HOMEBREW_VERSION='0.3t'
HOMEBREW_CACHE="/tmp/testbrew"
HOMEBREW_PREFIX=Pathname.new(HOMEBREW_CACHE)+'prefix'
HOMEBREW_CELLAR=Pathname.new(HOMEBREW_CACHE)+'cellar'

HOMEBREW_CELLAR.mkpath
raise "HOMEBREW_CELLAR couldn't be created!" unless HOMEBREW_CELLAR.directory?
at_exit { Pathname.new(HOMEBREW_CACHE).rmtree }
require 'test/unit' # must be after at_exit


class TestFormula <Formula
  def initialize url, md5='nomd5'
    @url=url
    @md5=md5
    super 'test'
  end
end

class TestBall <Formula
  def initialize
    @url="file:///#{Pathname.new(__FILE__).parent.realpath}/testball-0.1.tbz"
    super "testball"
  end
  
  def install
    prefix.install "bin"
    prefix.install "libexec"
  end
end

class TestBallValidMd5 <TestBall
  @md5='71aa838a9e4050d1876a295a9e62cbe6'
end

class TestBallInvalidMd5 <TestBall
  @md5='61aa838a9e4050d1876a295a9e62cbe6'
end


def nostdout
  tmp=$stdout
  $stdout=StringIO.new
  yield
  $stdout=tmp
end


class BeerTasting <Test::Unit::TestCase
  def test_version_all_dots
    r=TestFormula.new "http://example.com/foo.bar.la.1.14.zip"
    assert_equal '1.14', r.version
  end

  def test_version_underscore_separator
    r=TestFormula.new "http://example.com/grc_1.1.tar.gz"
    assert_equal '1.1', r.version
  end

  def test_boost_version_style
    r=TestFormula.new "http://example.com/boost_1_39_0.tar.bz2"
    assert_equal '1.39.0', r.version
  end

  def test_erlang_version_style
    r=TestFormula.new "http://erlang.org/download/otp_src_R13B.tar.gz"
    assert_equal 'R13B', r.version
  end
  
  def test_p7zip_version_style
    r=TestFormula.new "http://kent.dl.sourceforge.net/sourceforge/p7zip/p7zip_9.04_src_all.tar.bz2"
    assert_equal '9.04', r.version
  end
  
  def test_gloox_beta_style
    r=TestFormula.new "http://camaya.net/download/gloox-1.0-beta7.tar.bz2"
    assert_equal '1.0-beta7', r.version
  end
  
  def test_astyle_verson_style
    r=TestFormula.new "http://kent.dl.sourceforge.net/sourceforge/astyle/astyle_1.23_macosx.tar.gz"
    assert_equal '1.23', r.version
  end
  
  def test_version_libvorbis
    r=TestFormula.new "http://downloads.xiph.org/releases/vorbis/libvorbis-1.2.2rc1.tar.bz2"
    assert_equal '1.2.2rc1', r.version
  end
  
  def test_dos2unix
    r=TestFormula.new "http://www.sfr-fresh.com/linux/misc/dos2unix-3.1.tar.gz"
    assert_equal '3.1', r.version
  end

  def test_version_internal_dash
    r=TestFormula.new "http://example.com/foo-arse-1.1-2.tar.gz"
    assert_equal '1.1-2', r.version
  end

  def test_version_single_digit
    r=TestFormula.new "http://example.com/foo_bar.45.tar.gz"
    assert_equal '45', r.version
  end

  def test_noseparator_single_digit
    r=TestFormula.new "http://example.com/foo_bar45.tar.gz"
    assert_equal '45', r.version
  end

  def test_version_developer_that_hates_us_format
    r=TestFormula.new "http://example.com/foo-bar-la.1.2.3.tar.gz"
    assert_equal '1.2.3', r.version
  end

  def test_version_regular
    r=TestFormula.new "http://example.com/foo_bar-1.21.tar.gz"
    assert_equal '1.21', r.version
  end

  def test_yet_another_version
    r=TestFormula.new "http://example.com/mad-0.15.1b.tar.gz"
    assert_equal '0.15.1b', r.version
  end

  def test_supported_compressed_types
    assert_nothing_raised do
      TestFormula.new 'test-0.1.tar.gz'
      TestFormula.new 'test-0.1.tar.bz2'
      TestFormula.new 'test-0.1.tgz'
      TestFormula.new 'test-0.1.bgz'
      TestFormula.new 'test-0.1.zip'
    end
  end

  def test_prefix
    nostdout do
      TestBall.new.brew do |f|
        assert_equal File.expand_path(f.prefix), (HOMEBREW_CELLAR+f.name+'0.1').to_s
        assert_kind_of Pathname, f.prefix
      end
    end
  end
  
  def test_install
    f=TestBall.new
    nostdout do 
      f.brew do
        f.install
      end
    end
    
    assert f.bin.directory?
    assert_equal f.bin.children.length, 3
    libexec=f.prefix+'libexec'
    assert libexec.directory?
    assert_equal libexec.children.length, 1
    
    assert !(f.prefix+'main.c').exist?
    
    keg=Keg.new f
    keg.ln
    assert_equal HOMEBREW_PREFIX.children.length, 1
    assert (HOMEBREW_PREFIX+'bin').directory?
    assert_equal (HOMEBREW_PREFIX+'bin').children.length, 3
  end
  
  def test_md5
    assert_nothing_raised { nostdout { TestBallValidMd5.new.brew {} } }
  end
  
  def test_badmd5
    assert_raises RuntimeError do
      nostdout { TestBallInvalidMd5.new.brew {} } 
    end
  end
end
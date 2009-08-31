#!/usr/bin/ruby
# This software is in the public domain, furnished "as is", without technical
# support, and with no warranty, express or implied, as to its usefulness for
# any purpose.

$:.unshift File.dirname(__FILE__)
require 'pathname+yeast'
require 'formula'
require 'download_strategy'
require 'keg'
require 'utils'

# these are defined in bin/brew, but we don't want to break our actual
# homebrew tree, and we do want to test everything :)
HOMEBREW_PREFIX=Pathname.new '/tmp/testbrew/prefix'
HOMEBREW_CACHE=HOMEBREW_PREFIX.parent+"cache"
HOMEBREW_CELLAR=HOMEBREW_PREFIX.parent+"cellar"
HOMEBREW_USER_AGENT="Homebrew"

HOMEBREW_CELLAR.mkpath
raise "HOMEBREW_CELLAR couldn't be created!" unless HOMEBREW_CELLAR.directory?
at_exit { HOMEBREW_PREFIX.parent.rmtree }
require 'test/unit' # must be after at_exit
require 'ARGV+yeast' # needs to be after test/unit to avoid conflict with OptionsParser


class MockFormula <Formula
  def initialize url
    @url=url
    super 'test'
  end
end

class MostlyAbstractFormula <Formula
  @url=''
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

class TestZip <Formula
  def initialize
    zip=HOMEBREW_CACHE.parent+'test-0.1.zip'
    Kernel.system 'zip', '-0', zip, __FILE__
    @url="file://#{zip}"
    super 'testzip'
  end
end

class TestBallValidMd5 <TestBall
  @md5='71aa838a9e4050d1876a295a9e62cbe6'
end

class TestBallInvalidMd5 <TestBall
  @md5='61aa838a9e4050d1876a295a9e62cbe6'
end

class TestBadVersion <TestBall
  @version="versions can't have spaces"
end

class TestBallOverrideBrew <Formula
  def initialize
    super "foo"
  end
  def brew
  end
end

class TestScriptFileFormula <ScriptFileFormula
  @url="file:///#{Pathname.new(__FILE__).realpath}"
  @version="1"
  
  def initialize
    super
    @name='test-script-formula'
  end
end

def nostdout
  if ARGV.include? '-V'
    yield
  end
  begin
    require 'stringio'
    tmpo=$stdout
    tmpe=$stderr
    $stdout=StringIO.new
    yield
  ensure
    $stdout=tmpo
  end
end


class BeerTasting <Test::Unit::TestCase
  def test_version_all_dots
    r=MockFormula.new "http://example.com/foo.bar.la.1.14.zip"
    assert_equal '1.14', r.version
  end

  def test_version_underscore_separator
    r=MockFormula.new "http://example.com/grc_1.1.tar.gz"
    assert_equal '1.1', r.version
  end

  def test_boost_version_style
    r=MockFormula.new "http://example.com/boost_1_39_0.tar.bz2"
    assert_equal '1.39.0', r.version
  end

  def test_erlang_version_style
    r=MockFormula.new "http://erlang.org/download/otp_src_R13B.tar.gz"
    assert_equal 'R13B', r.version
  end
  
  def test_p7zip_version_style
    r=MockFormula.new "http://kent.dl.sourceforge.net/sourceforge/p7zip/p7zip_9.04_src_all.tar.bz2"
    assert_equal '9.04', r.version
  end
  
  def test_gloox_beta_style
    r=MockFormula.new "http://camaya.net/download/gloox-1.0-beta7.tar.bz2"
    assert_equal '1.0-beta7', r.version
  end
  
  def test_astyle_verson_style
    r=MockFormula.new "http://kent.dl.sourceforge.net/sourceforge/astyle/astyle_1.23_macosx.tar.gz"
    assert_equal '1.23', r.version
  end
  
  def test_version_libvorbis
    r=MockFormula.new "http://downloads.xiph.org/releases/vorbis/libvorbis-1.2.2rc1.tar.bz2"
    assert_equal '1.2.2rc1', r.version
  end
  
  def test_dos2unix
    r=MockFormula.new "http://www.sfr-fresh.com/linux/misc/dos2unix-3.1.tar.gz"
    assert_equal '3.1', r.version
  end

  def test_version_internal_dash
    r=MockFormula.new "http://example.com/foo-arse-1.1-2.tar.gz"
    assert_equal '1.1-2', r.version
  end

  def test_version_single_digit
    r=MockFormula.new "http://example.com/foo_bar.45.tar.gz"
    assert_equal '45', r.version
  end

  def test_noseparator_single_digit
    r=MockFormula.new "http://example.com/foo_bar45.tar.gz"
    assert_equal '45', r.version
  end

  def test_version_developer_that_hates_us_format
    r=MockFormula.new "http://example.com/foo-bar-la.1.2.3.tar.gz"
    assert_equal '1.2.3', r.version
  end

  def test_version_regular
    r=MockFormula.new "http://example.com/foo_bar-1.21.tar.gz"
    assert_equal '1.21', r.version
  end

  def test_version_github
    r=MockFormula.new "http://github.com/lloyd/yajl/tarball/1.0.5"
    assert_equal '1.0.5', r.version
  end

  def test_yet_another_version
    r=MockFormula.new "http://example.com/mad-0.15.1b.tar.gz"
    assert_equal '0.15.1b', r.version
  end

  def test_supported_compressed_types
    assert_nothing_raised do
      MockFormula.new 'test-0.1.tar.gz'
      MockFormula.new 'test-0.1.tar.bz2'
      MockFormula.new 'test-0.1.tgz'
      MockFormula.new 'test-0.1.bgz'
      MockFormula.new 'test-0.1.zip'
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
  
  def test_no_version
    assert_nil Pathname.new("http://example.com/blah.tar").version
    assert_nil Pathname.new("arse").version
  end
  
  def test_bad_version
    assert_raises(RuntimeError) {f=TestBadVersion.new}
  end
  
  def test_install
    f=TestBall.new
    
    assert_equal Formula.path(f.name), f.path
    assert !f.installed?
    
    nostdout do
      f.brew do
        f.install
      end
    end
    
    assert_match Regexp.new("^#{HOMEBREW_CELLAR}/"), f.prefix.to_s
    
    assert f.bin.directory?
    assert_equal 3, f.bin.children.length
    libexec=f.prefix+'libexec'
    assert libexec.directory?
    assert_equal 1, libexec.children.length
    assert !(f.prefix+'main.c').exist?
    assert f.installed?
    
    keg=Keg.new f.prefix
    keg.link
    assert_equal 2, HOMEBREW_PREFIX.children.length
    assert (HOMEBREW_PREFIX+'bin').directory?
    assert_equal 3, (HOMEBREW_PREFIX+'bin').children.length
    
    keg.uninstall
    assert !keg.exist?
    assert !f.installed?
  end
  
  def test_script_install
    f=TestScriptFileFormula.new
    
    nostdout do
      f.brew do
        f.install
      end
    end
    
    assert_equal 1, f.bin.children.length
  end

  def test_md5
    assert_nothing_raised { nostdout { TestBallValidMd5.new.brew {} } }
  end
  
  def test_badmd5
    assert_raises RuntimeError do
      nostdout { TestBallInvalidMd5.new.brew {} } 
    end
  end
  
  FOOBAR='foo-bar'
  def test_formula_funcs
    classname=Formula.class(FOOBAR)
    path=Formula.path(FOOBAR)
    
    assert_equal "FooBar", classname
    assert_match Regexp.new("^#{HOMEBREW_PREFIX}/Library/Formula"), path.to_s

    path=HOMEBREW_PREFIX+'Library'+'Formula'+"#{FOOBAR}.rb"
    path.dirname.mkpath
    `echo "require 'brewkit'; class #{classname} <Formula; @url=''; end" > #{path}`
    
    assert_not_nil Formula.factory(FOOBAR)
  end
  
  def test_cant_override_brew
    assert_raises(RuntimeError) { TestBallOverrideBrew.new }
  end
  
  def test_abstract_formula
    f=MostlyAbstractFormula.new
    assert_equal '__UNKNOWN__', f.name
    assert_raises(RuntimeError) { f.prefix }
    nostdout { assert_raises(RuntimeError) { f.brew } }
  end

  def test_zip
    nostdout { assert_nothing_raised { TestZip.new.brew {} } }
  end

  def test_no_ARGV_dupes
    ARGV.unshift'foo'
    ARGV.unshift'foo'
    n=0
    ARGV.named.each{|arg| n+=1 if arg == 'foo'}
    assert_equal 1, n
  end
  
  def test_ARGV
    assert_raises(UsageError) { ARGV.named }
    assert_raises(UsageError) { ARGV.formulae }
    assert_raises(UsageError) { ARGV.kegs }
    assert ARGV.named_empty?
    
    (HOMEBREW_CELLAR+'foo'+'0.1').mkpath
    
    ARGV.unshift 'foo'
    assert_equal 1, ARGV.named.length
    assert_equal 1, ARGV.kegs.length
    assert_raises(FormulaUnavailableError) { ARGV.formulae }
  end
  
  def test_version_dir
    d=HOMEBREW_CELLAR+'foo-0.1.9'
    d.mkpath
    assert_equal '0.1.9', d.version
  end
  
  def test_ruby_version_style
    f=MockFormula.new 'ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.1-p243.tar.gz'
    assert_equal '1.9.1-p243', f.version
  end
end

#!/usr/bin/ruby
# This software is in the public domain, furnished "as is", without technical
# support, and with no warranty, express or implied, as to its usefulness for
# any purpose.

ABS__FILE__=File.expand_path(__FILE__)

$:.unshift File.dirname(ABS__FILE__)
require 'pathname+yeast'
require 'formula'
require 'download_strategy'
require 'keg'
require 'utils'
require 'brew.h'
require 'hardware'
require 'update'

# these are defined in global.rb, but we don't want to break our actual
# homebrew tree, and we do want to test everything :)
HOMEBREW_PREFIX=Pathname.new '/private/tmp/testbrew/prefix'
HOMEBREW_CACHE=HOMEBREW_PREFIX.parent+"cache"
HOMEBREW_CELLAR=HOMEBREW_PREFIX.parent+"cellar"
HOMEBREW_USER_AGENT="Homebrew"
MACOS_VERSION=10.6

(HOMEBREW_PREFIX+'Library'+'Formula').mkpath
Dir.chdir HOMEBREW_PREFIX
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
  # name parameter required for some Formula::factory
  def initialize name=nil
    @url="file:///#{Pathname.new(ABS__FILE__).parent.realpath}/testball-0.1.tbz"
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
    Kernel.system '/usr/bin/zip', '-0', zip, ABS__FILE__
    @url="file://#{zip}"
    super 'testzip'
  end
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
  url "file:///#{Pathname.new(ABS__FILE__).realpath}"
  version "1"
  
  def initialize
    super
    @name='test-script-formula'
  end
end

class RefreshBrewMock < RefreshBrew
  def in_prefix_expect(expect, returns = '')
    @expect ||= {}
    @expect[expect] = returns
  end
  
  def `(cmd)
    if Dir.pwd == HOMEBREW_PREFIX.to_s and @expect.has_key?(cmd)
      (@called ||= []) << cmd
      @expect[cmd]
    else
      raise "#{inspect} Unexpectedly called backticks in pwd `#{HOMEBREW_PREFIX}' and command `#{cmd}'"
    end
  end
  
  def expectations_met?
    @expect.keys == @called
  end
  
  def inspect
    "#<#{self.class.name} #{object_id}>"
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

module ExtendArgvPlusYeast
  def reset
    @named=nil
    @formulae=nil
    @kegs=nil
    while ARGV.count > 0
      ARGV.shift
    end
  end
end
ARGV.extend ExtendArgvPlusYeast


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
    valid_md5 = Class.new(TestBall) do
      @md5='71aa838a9e4050d1876a295a9e62cbe6'
    end

    assert_nothing_raised { nostdout { valid_md5.new.brew {} } }
  end
  
  def test_badmd5
    invalid_md5 = Class.new(TestBall) do
      @md5='61aa838a9e4050d1876a295a9e62cbe6'
    end

    assert_raises RuntimeError do
      nostdout { invalid_md5.new.brew {} }
    end
  end

  def test_sha1
    valid_sha1 = Class.new(TestBall) do
      @sha1='6ea8a98acb8f918df723c2ae73fe67d5664bfd7e'
    end

    assert_nothing_raised { nostdout { valid_sha1.new.brew {} } }
  end

  def test_badsha1
    invalid_sha1 = Class.new(TestBall) do
      @sha1='7ea8a98acb8f918df723c2ae73fe67d5664bfd7e'
    end

    assert_raises RuntimeError do
      nostdout { invalid_sha1.new.brew {} }
    end
  end

  def test_sha256
    valid_sha256 = Class.new(TestBall) do
      @sha256='ccbf5f44743b74add648c7e35e414076632fa3b24463d68d1f6afc5be77024f8'
    end

    assert_nothing_raised do
      nostdout { valid_sha256.new.brew {} }
    end
  end

  def test_badsha256
    invalid_sha256 = Class.new(TestBall) do
      @sha256='dcbf5f44743b74add648c7e35e414076632fa3b24463d68d1f6afc5be77024f8'
    end

    assert_raises RuntimeError do
      nostdout { invalid_sha256.new.brew {} }
    end
  end
  
  FOOBAR='foo-bar'
  def test_formula_funcs
    classname=Formula.class_s(FOOBAR)
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
    ARGV.reset
    ARGV.unshift 'foo'
    ARGV.unshift 'foo'
    n=0
    ARGV.named.each{|arg| n+=1 if arg == 'foo'}
    assert_equal 1, n
  end
  
  def test_ARGV
    assert_raises(UsageError) { ARGV.named }
    assert_raises(UsageError) { ARGV.formulae }
    assert_raises(UsageError) { ARGV.kegs }
    assert ARGV.named_empty?
    
    (HOMEBREW_CELLAR+'mxcl'+'10.0').mkpath
    
    ARGV.reset
    ARGV.unshift 'mxcl'
    assert_equal 1, ARGV.named.length
    assert_equal 1, ARGV.kegs.length
    assert_raises(FormulaUnavailableError) { ARGV.formulae }
  end
  
  def test_version_dir
    d=HOMEBREW_CELLAR+'foo-0.1.9'
    d.mkpath
    assert_equal '0.1.9', d.version
  end
  
  def test_lame_version_style
    f=MockFormula.new 'http://kent.dl.sourceforge.net/sourceforge/lame/lame-398-2.tar.gz'
    assert_equal '398-2', f.version
  end
  
  def test_ruby_version_style
    f=MockFormula.new 'ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.1-p243.tar.gz'
    assert_equal '1.9.1-p243', f.version
  end
  
  # these will raise if we don't recognise your mac, but that prolly 
  # indicates something went wrong rather than we don't know
  def test_hardware_cpu_type
    assert [:intel, :ppc].include?(Hardware.cpu_type)
  end
  
  def test_hardware_intel_family
    if Hardware.cpu_type == :intel
      assert [:core, :core2, :penryn, :nehalem].include?(Hardware.intel_family)
    end
  end
  
  def test_brew_h
    nostdout do
      assert_nothing_raised do
        f=TestBall.new
        make f.url
        info f.name
        clean f
        prune
        #TODO test diy function too
      end
    end
  end
  
  def test_my_float_assumptions
    # this may look ridiculous but honestly there's code in brewit that depends on 
    # this behaviour so I wanted to be certain Ruby floating points are behaving
    f='10.6'.to_f
    assert_equal 10.6, f
    assert f >= 10.6
    assert f <= 10.6
    assert_equal 10.5, f-0.1
    assert_equal 10.7, f+0.1
  end

  def test_arch_for_command
    arches=arch_for_command '/usr/bin/svn'
    if `sw_vers -productVersion` =~ /10\.(\d+)/ and $1.to_i >= 6
      assert_equal 3, arches.count
      assert arches.include?(:x86_64)
    else
      assert_equal 2, arches.count
    end
    assert arches.include?(:i386)
    assert arches.include?(:ppc7400)
  end

  def test_pathname_plus_yeast
    nostdout do
      assert_nothing_raised do
        assert !Pathname.getwd.rmdir_if_possible
        assert !Pathname.getwd.abv.empty?
        
        abcd=orig_abcd=HOMEBREW_CACHE+'abcd'
        FileUtils.cp ABS__FILE__, abcd
        abcd=HOMEBREW_PREFIX.install abcd
        assert (HOMEBREW_PREFIX+orig_abcd.basename).exist?
        assert abcd.exist?
        assert_equal HOMEBREW_PREFIX+'abcd', abcd

        assert_raises(RuntimeError) {abcd.write 'CONTENT'}
        abcd.unlink
        abcd.write 'HELLOWORLD'
        assert_equal 'HELLOWORLD', File.read(abcd)
        
        assert !orig_abcd.exist?
        rv=abcd.cp orig_abcd
        assert orig_abcd.exist?
        assert_equal rv, orig_abcd

        orig_abcd.unlink
        assert !orig_abcd.exist?
        abcd.cp HOMEBREW_CACHE
        assert orig_abcd.exist?

        foo1=HOMEBREW_CACHE+'foo-0.1.tar.gz'
        FileUtils.cp ABS__FILE__, foo1
        assert foo1.file?
        
        assert_equal '.tar.gz', foo1.extname
        assert_equal 'foo-0.1', foo1.stem
        assert_equal '0.1', foo1.version
        
        HOMEBREW_CACHE.chmod_R 0777
      end
    end
    
    assert_raises(RuntimeError) {Pathname.getwd.install 'non_existant_file'}
  end
  
  def test_omega_version_style
    f=MockFormula.new 'http://www.alcyone.com/binaries/omega/omega-0.80.2-src.tar.gz'
    assert_equal '0.80.2', f.version
  end
  
  def test_formula_class_func
    assert_equal Formula.class_s('s-lang'), 'SLang'
    assert_equal Formula.class_s('pkg-config'), 'PkgConfig'
    assert_equal Formula.class_s('foo_bar'), 'FooBar'
  end
  
  def test_version_style_rc
    f=MockFormula.new 'http://ftp.mozilla.org/pub/mozilla.org/js/js-1.8.0-rc1.tar.gz'
    assert_equal '1.8.0-rc1', f.version
  end
  
  def test_updater_update_homebrew_without_any_changes
    outside_prefix do
      updater = RefreshBrewMock.new
      updater.in_prefix_expect("git checkout master")
      updater.in_prefix_expect("git pull origin master", "Already up-to-date.\n")
      
      assert_equal false, updater.update_from_masterbrew!
      assert updater.expectations_met?
      assert updater.updated_formulae.empty?
    end
  end
  
  def test_updater_update_homebrew_without_formulae_changes
    outside_prefix do
      updater = RefreshBrewMock.new
      updater.in_prefix_expect("git checkout master")
      output = fixture('update_git_pull_output_without_formulae_changes')
      updater.in_prefix_expect("git pull origin master", output)
      
      assert_equal true, updater.update_from_masterbrew!
      assert !updater.pending_formulae_changes?
      assert updater.updated_formulae.empty?
    end
  end
  
  def test_updater_update_homebrew_with_formulae_changes
    outside_prefix do
      updater = RefreshBrewMock.new
      updater.in_prefix_expect("git checkout master")
      output = fixture('update_git_pull_output_with_formulae_changes')
      updater.in_prefix_expect("git pull origin master", output)
      
      assert_equal true, updater.update_from_masterbrew!
      assert updater.pending_formulae_changes?
      assert_equal %w{ antiword bash-completion xar yajl }, updater.updated_formulae
    end
  end
  
  def test_updater_returns_current_revision
    outside_prefix do
      updater = RefreshBrewMock.new
      updater.in_prefix_expect('git log -l -1 --pretty=format:%H', 'the-revision-hash')
      assert_equal 'the-revision-hash', updater.current_revision
    end
  end
  
  private
  
  OUTSIDE_PREFIX = '/tmp'
  def outside_prefix
    Dir.chdir(OUTSIDE_PREFIX) { yield }
  end
  
  def fixture(name)
    self.class.fixture_data[name]
  end
  
  def self.fixture_data
    unless @fixture_data
      require 'yaml'
      @fixture_data = YAML.load(DATA)
    end
    @fixture_data
  end
end

__END__
update_git_pull_output_without_formulae_changes: |
  remote: Counting objects: 58, done.
  remote: Compressing objects: 100% (35/35), done.
  remote: Total 39 (delta 20), reused 0 (delta 0)
  Unpacking objects: 100% (39/39), done.
  From git://github.com/mxcl/homebrew
   * branch            master -> FETCH_HEAD
  Updating 14ef7f9..f414bc8
  Fast forward
   Library/Homebrew/ARGV+yeast.rb                |   35 ++--
   Library/Homebrew/beer_events.rb               |  181 +++++++++++++
   Library/Homebrew/hardware.rb                  |   71 ++++++
   Library/Homebrew/hw.model.c                   |   17 --
   README                                        |  337 +++++++++++++------------
   bin/brew                                      |  137 ++++++++---
   40 files changed, 1107 insertions(+), 426 deletions(-)
   create mode 100644 Library/Homebrew/beer_events.rb
   create mode 100644 Library/Homebrew/hardware.rb
   delete mode 100644 Library/Homebrew/hw.model.c
   delete mode 100644 Library/Homebrew/hw.model.rb
update_git_pull_output_with_formulae_changes: |
  remote: Counting objects: 58, done.
  remote: Compressing objects: 100% (35/35), done.
  remote: Total 39 (delta 20), reused 0 (delta 0)
  Unpacking objects: 100% (39/39), done.
  From git://github.com/mxcl/homebrew
   * branch            master -> FETCH_HEAD
  Updating 14ef7f9..f414bc8
  Fast forward
   Library/Contributions/brew_bash_completion.sh |    6 +-
   Library/Formula/antiword.rb                   |   13 +
   Library/Formula/bash-completion.rb            |   25 ++
   Library/Formula/xar.rb                        |   19 ++
   Library/Formula/yajl.rb                       |    2 +-
   Library/Homebrew/ARGV+yeast.rb                |   35 ++--
   Library/Homebrew/beer_events.rb               |  181 +++++++++++++
   Library/Homebrew/hardware.rb                  |   71 ++++++
   Library/Homebrew/hw.model.c                   |   17 --
   Library/Homebrew/pathname+yeast.rb            |   28 ++-
   Library/Homebrew/unittest.rb                  |  106 ++++++++-
   Library/Homebrew/utils.rb                     |   36 ++-
   README                                        |  337 +++++++++++++------------
   bin/brew                                      |  137 ++++++++---
   40 files changed, 1107 insertions(+), 426 deletions(-)
   create mode 100644 Library/Formula/antiword.rb
   create mode 100644 Library/Formula/bash-completion.rb
   create mode 100644 Library/Formula/ddrescue.rb
   create mode 100644 Library/Formula/dict.rb
   create mode 100644 Library/Formula/lua.rb
   delete mode 100644 Library/Formula/antiword.rb
   delete mode 100644 Library/Formula/bash-completion.rb
   delete mode 100644 Library/Formula/xar.rb
   delete mode 100644 Library/Formula/yajl.rb
   create mode 100644 Library/Homebrew/beer_events.rb
   create mode 100644 Library/Homebrew/hardware.rb
   delete mode 100644 Library/Homebrew/hw.model.c
   delete mode 100644 Library/Homebrew/hw.model.rb
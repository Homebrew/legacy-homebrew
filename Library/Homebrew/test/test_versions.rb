require 'testing_env'
require 'formula'
require 'test/testball'
require 'version'

class TestBadVersion < TestBall
  def initialize name=nil
    @stable = SoftwareSpec.new
    @stable.version "versions can't have spaces"
    super 'testbadversion'
  end
end

class VersionComparisonTests < Test::Unit::TestCase
  include VersionAssertions

  def test_version_comparisons
    assert_equal 0,  version('0.1') <=> version('0.1.0')
    assert_equal -1, version('0.1') <=> version('0.2')
    assert_equal 1,  version('1.2.3') <=> version('1.2.2')
    assert_equal 1,  version('1.2.3-p34') <=> version('1.2.3-p33')
    assert_equal -1, version('1.2.4') <=> version('1.2.4.1')
    assert_equal 0,  version('HEAD') <=> version('HEAD')
    assert_equal 1,  version('HEAD') <=> version('1.2.3')
    assert_equal -1, version('1.2.3') <=> version('HEAD')
    assert_equal -1, version('3.2.0b4') <=> version('3.2.0')
    assert_equal -1, version('1.0beta6') <=> version('1.0b7')
    assert_equal -1, version('1.0b6') <=> version('1.0beta7')
    assert_equal -1, version('1.1alpha4') <=> version('1.1beta2')
    assert_equal -1, version('1.1beta2') <=> version('1.1rc1')
    assert_equal -1, version('1.0.0beta7') <=> version('1.0.0')
    assert_equal 1,  version('3.2.1') <=> version('3.2beta4')
    assert_nil version('1.0') <=> 'foo'
  end

  def test_version_interrogation
    v = Version.new("1.1alpha1")
    assert v.alpha?
    v = Version.new("1.0beta2")
    assert v.devel?
    assert v.beta?
    v = Version.new("1.0rc-1")
    assert v.devel?
    assert v.rc?
  end
end

class VersionParsingTests < Test::Unit::TestCase
  include VersionAssertions

  def test_pathname_version
    d = HOMEBREW_CELLAR/'foo-0.1.9'
    d.mkpath
    assert_equal 0, version('0.1.9') <=> d.version
  end

  def test_no_version
    assert_version_nil 'http://example.com/blah.tar'
    assert_version_nil 'foo'
  end

  def test_bad_version
    assert_raises(RuntimeError) { TestBadVersion.new }
  end

  def test_version_all_dots
    assert_version_detected '1.14', 'http://example.com/foo.bar.la.1.14.zip'
  end

  def test_version_underscore_separator
    assert_version_detected '1.1', 'http://example.com/grc_1.1.tar.gz'
  end

  def test_boost_version_style
    assert_version_detected '1.39.0', 'http://example.com/boost_1_39_0.tar.bz2'
  end

  def test_erlang_version_style
    assert_version_detected 'R13B', 'http://erlang.org/download/otp_src_R13B.tar.gz'
  end

  def test_another_erlang_version_style
    assert_version_detected 'R15B01', 'https://github.com/erlang/otp/tarball/OTP_R15B01'
  end

  def test_yet_another_erlang_version_style
    assert_version_detected 'R15B03-1', 'https://github.com/erlang/otp/tarball/OTP_R15B03-1'
  end

  def test_p7zip_version_style
    assert_version_detected '9.04',
      'http://kent.dl.sourceforge.net/sourceforge/p7zip/p7zip_9.04_src_all.tar.bz2'
  end

  def test_new_github_style
    assert_version_detected '1.1.4', 'https://github.com/sam-github/libnet/tarball/libnet-1.1.4'
  end

  def test_gloox_beta_style
    assert_version_detected '1.0-beta7', 'http://camaya.net/download/gloox-1.0-beta7.tar.bz2'
  end

  def test_sphinx_beta_style
    assert_version_detected '1.10-beta', 'http://sphinxsearch.com/downloads/sphinx-1.10-beta.tar.gz'
  end

  def test_astyle_verson_style
    assert_version_detected '1.23', 'http://kent.dl.sourceforge.net/sourceforge/astyle/astyle_1.23_macosx.tar.gz'
  end

  def test_version_dos2unix
    assert_version_detected '3.1', 'http://www.sfr-fresh.com/linux/misc/dos2unix-3.1.tar.gz'
  end

  def test_version_internal_dash
    assert_version_detected '1.1-2', 'http://example.com/foo-arse-1.1-2.tar.gz'
  end

  def test_version_single_digit
    assert_version_detected '45', 'http://example.com/foo_bar.45.tar.gz'
  end

  def test_noseparator_single_digit
    assert_version_detected '45', 'http://example.com/foo_bar45.tar.gz'
  end

  def test_version_developer_that_hates_us_format
    assert_version_detected '1.2.3', 'http://example.com/foo-bar-la.1.2.3.tar.gz'
  end

  def test_version_regular
    assert_version_detected '1.21', 'http://example.com/foo_bar-1.21.tar.gz'
  end

  def test_version_sourceforge_download
    assert_version_detected '1.21', 'http://sourceforge.net/foo_bar-1.21.tar.gz/download'
    assert_version_detected '1.21', 'http://sf.net/foo_bar-1.21.tar.gz/download'
  end

  def test_version_github
    assert_version_detected '1.0.5', 'http://github.com/lloyd/yajl/tarball/1.0.5'
  end

  def test_version_github_with_high_patch_number
    assert_version_detected '1.2.34', 'http://github.com/lloyd/yajl/tarball/v1.2.34'
  end

  def test_yet_another_version
    assert_version_detected '0.15.1b', 'http://example.com/mad-0.15.1b.tar.gz'
  end

  def test_lame_version_style
    assert_version_detected '398-2', 'http://kent.dl.sourceforge.net/sourceforge/lame/lame-398-2.tar.gz'
  end

  def test_ruby_version_style
    assert_version_detected '1.9.1-p243', 'ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.1-p243.tar.gz'
  end

  def test_omega_version_style
    assert_version_detected '0.80.2', 'http://www.alcyone.com/binaries/omega/omega-0.80.2-src.tar.gz'
  end

  def test_rc_style
    assert_version_detected '1.2.2rc1', 'http://downloads.xiph.org/releases/vorbis/libvorbis-1.2.2rc1.tar.bz2'
  end

  def test_dash_rc_style
    assert_version_detected '1.8.0-rc1', 'http://ftp.mozilla.org/pub/mozilla.org/js/js-1.8.0-rc1.tar.gz'
  end

  def test_angband_version_style
    assert_version_detected '3.0.9b', 'http://rephial.org/downloads/3.0/angband-3.0.9b-src.tar.gz'
  end

  def test_stable_suffix
    assert_version_detected '1.4.14b', 'http://www.monkey.org/~provos/libevent-1.4.14b-stable.tar.gz'
  end

  def test_debian_style_1
    assert_version_detected '3.03', 'http://ftp.de.debian.org/debian/pool/main/s/sl/sl_3.03.orig.tar.gz'
  end

  def test_debian_style_2
    assert_version_detected '1.01b', 'http://ftp.de.debian.org/debian/pool/main/m/mmv/mmv_1.01b.orig.tar.gz'
  end

  def test_bottle_style
    assert_version_detected '4.8.0', 'https://downloads.sf.net/project/machomebrew/Bottles/qt-4.8.0.lion.bottle.tar.gz'
  end

  def test_versioned_bottle_style
    assert_version_detected '4.8.1', 'https://downloads.sf.net/project/machomebrew/Bottles/qt-4.8.1.lion.bottle.1.tar.gz'
  end

  def test_erlang_bottle_style
    assert_version_detected 'R15B', 'https://downloads.sf.net/project/machomebrew/Bottles/erlang-R15B.lion.bottle.tar.gz'
  end

  def test_another_erlang_bottle_style
    assert_version_detected 'R15B01', 'https://downloads.sf.net/project/machomebrew/Bottles/erlang-R15B01.mountain_lion.bottle.tar.gz'
  end

  def test_yet_another_erlang_bottle_style
    assert_version_detected 'R15B03-1', 'https://downloads.sf.net/project/machomebrew/Bottles/erlang-R15B03-1.mountainlion.bottle.tar.gz'
  end

  def test_imagemagick_style
    assert_version_detected '6.7.5-7', 'http://downloads.sf.net/project/machomebrew/mirror/ImageMagick-6.7.5-7.tar.bz2'
  end

  def test_imagemagick_bottle_style
    assert_version_detected '6.7.5-7', 'https://downloads.sf.net/project/machomebrew/Bottles/imagemagick-6.7.5-7.lion.bottle.tar.gz'
  end

  def test_imagemagick_versioned_bottle_style
    assert_version_detected '6.7.5-7', 'https://downloads.sf.net/project/machomebrew/Bottles/imagemagick-6.7.5-7.lion.bottle.1.tar.gz'
  end

  def test_dash_version_dash_style
    assert_version_detected '3.4', 'http://www.antlr.org/download/antlr-3.4-complete.jar'
  end

  def test_jenkins_version_style
    assert_version_detected '1.486', 'http://mirrors.jenkins-ci.org/war/1.486/jenkins.war'
  end

  def test_apache_version_style
    assert_version_detected '1.2.0-rc2', 'http://www.apache.org/dyn/closer.cgi?path=/cassandra/1.2.0/apache-cassandra-1.2.0-rc2-bin.tar.gz'
  end

  def test_jpeg_style
    assert_version_detected '8d', 'http://www.ijg.org/files/jpegsrc.v8d.tar.gz'
  end

  # def test_version_ghc_style
  #   assert_version_detected '7.0.4', 'http://www.haskell.org/ghc/dist/7.0.4/ghc-7.0.4-x86_64-apple-darwin.tar.bz2'
  #   assert_version_detected '7.0.4', 'http://www.haskell.org/ghc/dist/7.0.4/ghc-7.0.4-i386-apple-darwin.tar.bz2'
  # end

  def test_more_versions
    assert_version_detected '1.4.1', 'http://pypy.org/download/pypy-1.4.1-osx.tar.bz2'
    assert_version_detected '0.9.8s', 'http://www.openssl.org/source/openssl-0.9.8s.tar.gz'
    assert_version_detected '1.5E', 'ftp://ftp.visi.com/users/hawkeyd/X/Xaw3d-1.5E.tar.gz'
    assert_version_detected '2.0.863', 'http://downloads.sourceforge.net/project/assimp/assimp-2.0/assimp--2.0.863-sdk.zip'
    assert_version_detected '20c', 'http://common-lisp.net/project/cmucl/downloads/release/20c/cmucl-20c-x86-darwin.tar.bz2'
    assert_version_detected '2.1.0beta', 'http://downloads.sourceforge.net/project/fann/fann/2.1.0beta/fann-2.1.0beta.zip'
    assert_version_detected '2.0.1', 'ftp://iges.org/grads/2.0/grads-2.0.1-bin-darwin9.8-intel.tar.gz'
    assert_version_detected '2.08', 'http://haxe.org/file/haxe-2.08-osx.tar.gz'
    assert_version_detected '2007f', 'ftp://ftp.cac.washington.edu/imap/imap-2007f.tar.gz'
    assert_version_detected '3.3.12ga7', 'http://sourceforge.net/projects/x3270/files/x3270/3.3.12ga7/suite3270-3.3.12ga7-src.tgz'
    assert_version_detected '2.9h', 'http://www.gedanken.demon.co.uk/download-wwwoffle/wwwoffle-2.9h.tgz'
    assert_version_detected '1.3.6p2', 'http://synergy.googlecode.com/files/synergy-1.3.6p2-MacOSX-Universal.zip'
  end
end

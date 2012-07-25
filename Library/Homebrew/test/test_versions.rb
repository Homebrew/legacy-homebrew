require 'testing_env'
require 'formula'
require 'test/testball'

class MockFormula < Formula
  def initialize url
    @url=url
    @homepage = 'http://example.com/'
    super 'test'
  end
end

class TestBadVersion < TestBall
  @version="versions can't have spaces"
end


class VersionTests < Test::Unit::TestCase
  def test_pathname_version
    d=HOMEBREW_CELLAR+'foo-0.1.9'
    d.mkpath
    assert_equal '0.1.9', d.version
  end

  def test_no_version
    assert_nil Pathname.new("http://example.com/blah.tar").version
    assert_nil Pathname.new("arse").version
  end

  def test_bad_version
    assert_raises(RuntimeError) {f=TestBadVersion.new}
  end

  def check pathname, version
    r=MockFormula.new pathname
    assert_equal version, r.version
  end

  def test_version_all_dots
    check "http://example.com/foo.bar.la.1.14.zip", '1.14'
  end

  def test_version_underscore_separator
    check "http://example.com/grc_1.1.tar.gz", '1.1'
  end

  def test_boost_version_style
    check "http://example.com/boost_1_39_0.tar.bz2", '1.39.0'
  end

  def test_erlang_version_style
    check "http://erlang.org/download/otp_src_R13B.tar.gz", 'R13B'
  end

  def test_p7zip_version_style
    check "http://kent.dl.sourceforge.net/sourceforge/p7zip/p7zip_9.04_src_all.tar.bz2",
      '9.04'
  end

  def test_new_github_style
    check "https://github.com/sam-github/libnet/tarball/libnet-1.1.4", "1.1.4"
  end

  def test_gloox_beta_style
    check "http://camaya.net/download/gloox-1.0-beta7.tar.bz2", '1.0-beta7'
  end

  def test_sphinx_beta_style
    check 'http://sphinxsearch.com/downloads/sphinx-1.10-beta.tar.gz', '1.10-beta'
  end

  def test_astyle_verson_style
    check "http://kent.dl.sourceforge.net/sourceforge/astyle/astyle_1.23_macosx.tar.gz",
      '1.23'
  end

  def test_version_dos2unix
    check "http://www.sfr-fresh.com/linux/misc/dos2unix-3.1.tar.gz", '3.1'
  end

  def test_version_internal_dash
    check "http://example.com/foo-arse-1.1-2.tar.gz", '1.1-2'
  end

  def test_version_single_digit
    check "http://example.com/foo_bar.45.tar.gz", '45'
  end

  def test_noseparator_single_digit
    check "http://example.com/foo_bar45.tar.gz", '45'
  end

  def test_version_developer_that_hates_us_format
    check "http://example.com/foo-bar-la.1.2.3.tar.gz", '1.2.3'
  end

  def test_version_regular
    check "http://example.com/foo_bar-1.21.tar.gz", '1.21'
  end

  def test_version_sourceforge_download
    check "http://sourceforge.net/foo_bar-1.21.tar.gz/download", '1.21'
    check "http://sf.net/foo_bar-1.21.tar.gz/download", '1.21'
  end

  def test_version_github
    check "http://github.com/lloyd/yajl/tarball/1.0.5", '1.0.5'
  end

  def test_version_github_with_high_patch_number
    check "http://github.com/lloyd/yajl/tarball/v1.2.34", '1.2.34'
  end

  def test_yet_another_version
    check "http://example.com/mad-0.15.1b.tar.gz", '0.15.1b'
  end

  def test_lame_version_style
    check 'http://kent.dl.sourceforge.net/sourceforge/lame/lame-398-2.tar.gz',
      '398-2'
  end

  def test_ruby_version_style
    check 'ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.1-p243.tar.gz',
      '1.9.1-p243'
  end

  def test_omega_version_style
    check 'http://www.alcyone.com/binaries/omega/omega-0.80.2-src.tar.gz',
      '0.80.2'
  end

  def test_rc_style
    check "http://downloads.xiph.org/releases/vorbis/libvorbis-1.2.2rc1.tar.bz2",
      '1.2.2rc1'
  end

  def test_dash_rc_style
    check 'http://ftp.mozilla.org/pub/mozilla.org/js/js-1.8.0-rc1.tar.gz',
      '1.8.0-rc1'
  end

  def test_angband_version_style
    check 'http://rephial.org/downloads/3.0/angband-3.0.9b-src.tar.gz',
      '3.0.9b'
  end

  def test_stable_suffix
    check 'http://www.monkey.org/~provos/libevent-1.4.14b-stable.tar.gz',
      '1.4.14b'
  end

  def test_debian_style_1
    check 'http://ftp.de.debian.org/debian/pool/main/s/sl/sl_3.03.orig.tar.gz',
      '3.03'
  end

  def test_debian_style_2
    check 'http://ftp.de.debian.org/debian/pool/main/m/mmv/mmv_1.01b.orig.tar.gz',
      '1.01b'
  end

  def test_bottle_style
    check 'https://downloads.sf.net/project/machomebrew/Bottles/qt-4.8.0.lion.bottle.tar.gz',
      '4.8.0'
  end

  def test_versioned_bottle_style
    check 'https://downloads.sf.net/project/machomebrew/Bottles/qt-4.8.1.lion.bottle.1.tar.gz',
      '4.8.1'
  end

  def test_erlang_bottle_style
    check 'https://downloads.sf.net/project/machomebrew/Bottles/erlang-R15B.lion.bottle.tar.gz',
      'R15B'
  end

  def test_old_bottle_style
    check 'https://downloads.sf.net/project/machomebrew/Bottles/qt-4.7.3-bottle.tar.gz',
      '4.7.3'
  end

  def test_old_erlang_bottle_style
    check 'https://downloads.sf.net/project/machomebrew/Bottles/erlang-R15B-bottle.tar.gz',
      'R15B'
  end

  def test_imagemagick_style
    check 'http://downloads.sf.net/project/machomebrew/mirror/ImageMagick-6.7.5-7.tar.bz2',
      '6.7.5-7'
  end

  def test_imagemagick_bottle_style
    check 'https://downloads.sf.net/project/machomebrew/Bottles/imagemagick-6.7.5-7.lion.bottle.tar.gz',
      '6.7.5-7'
  end

  def test_imagemagick_versioned_bottle_style
    check 'https://downloads.sf.net/project/machomebrew/Bottles/imagemagick-6.7.5-7.lion.bottle.1.tar.gz',
      '6.7.5-7'
  end

  def test_dash_version_dash_style
    check 'http://www.antlr.org/download/antlr-3.4-complete.jar', '3.4'
  end

  def check_ghc_style
    check 'http://www.haskell.org/ghc/dist/7.0.4/ghc-7.0.4-x86_64-apple-darwin.tar.bz2', '7.0.4'
    check 'http://www.haskell.org/ghc/dist/7.0.4/ghc-7.0.4-i386-apple-darwin.tar.bz2', '7.0.4'
  end

  def test_more_versions
    check 'http://pypy.org/download/pypy-1.4.1-osx.tar.bz2', '1.4.1'
    check 'http://www.openssl.org/source/openssl-0.9.8s.tar.gz', '0.9.8s'
    check 'ftp://ftp.visi.com/users/hawkeyd/X/Xaw3d-1.5E.tar.gz', '1.5E'
    check 'http://downloads.sourceforge.net/project/assimp/assimp-2.0/assimp--2.0.863-sdk.zip',
      '2.0.863'
    check 'http://common-lisp.net/project/cmucl/downloads/release/20c/cmucl-20c-x86-darwin.tar.bz2',
      '20c'
    check 'http://downloads.sourceforge.net/project/fann/fann/2.1.0beta/fann-2.1.0beta.zip',
      '2.1.0beta'
    check 'ftp://iges.org/grads/2.0/grads-2.0.1-bin-darwin9.8-intel.tar.gz', '2.0.1'
    check 'http://haxe.org/file/haxe-2.08-osx.tar.gz', '2.08'
    check 'ftp://ftp.cac.washington.edu/imap/imap-2007f.tar.gz', '2007f'
    check 'http://sourceforge.net/projects/x3270/files/x3270/3.3.12ga7/suite3270-3.3.12ga7-src.tgz',
      '3.3.12ga7'
    check 'http://www.gedanken.demon.co.uk/download-wwwoffle/wwwoffle-2.9h.tgz', '2.9h'
    check 'http://synergy.googlecode.com/files/synergy-1.3.6p2-MacOSX-Universal.zip', '1.3.6p2'
  end
end

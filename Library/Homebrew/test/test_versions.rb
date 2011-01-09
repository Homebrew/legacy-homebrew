require 'testing_env'

require 'extend/ARGV' # needs to be after test/unit to avoid conflict with OptionsParser
ARGV.extend(HomebrewArgvExtension)

require 'formula'
require 'test/testball'

class MockFormula <Formula
  def initialize url
    @url=url
    @homepage = 'http://example.com/'
    super 'test'
  end
end

class TestBadVersion <TestBall
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
end

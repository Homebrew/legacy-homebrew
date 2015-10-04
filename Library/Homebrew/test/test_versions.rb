require "testing_env"
require "version"

class VersionTests < Homebrew::TestCase
  def test_accepts_objects_responding_to_to_str
    value = stub(:to_str => "0.1")
    assert_equal "0.1", Version.new(value).to_s
  end

  def test_raises_for_non_string_objects
    assert_raises(TypeError) { Version.new(1.1) }
    assert_raises(TypeError) { Version.new(1) }
    assert_raises(TypeError) { Version.new(:symbol) }
  end
end

class VersionComparisonTests < Homebrew::TestCase
  def test_version_comparisons
    assert_operator version("0.1"), :==, version("0.1.0")
    assert_operator version("0.1"), :<, version("0.2")
    assert_operator version("1.2.3"), :>, version("1.2.2")
    assert_operator version("1.2.4"), :<, version("1.2.4.1")
  end

  def test_patchlevel
    assert_operator version("1.2.3-p34"), :>, version("1.2.3-p33")
    assert_operator version("1.2.3-p33"), :<, version("1.2.3-p34")
    assert_operator version("1.2.3-p10"), :>, version("1.2.3-p9")
  end

  def test_HEAD
    assert_operator version("HEAD"), :>, version("1.2.3")
    assert_operator version("1.2.3"), :<, version("HEAD")
  end

  def test_alpha_beta_rc
    assert_operator version("3.2.0b4"), :<, version("3.2.0")
    assert_operator version("1.0beta6"), :<, version("1.0b7")
    assert_operator version("1.0b6"), :<, version("1.0beta7")
    assert_operator version("1.1alpha4"), :<, version("1.1beta2")
    assert_operator version("1.1beta2"), :<, version("1.1rc1")
    assert_operator version("1.0.0beta7"), :<, version("1.0.0")
    assert_operator version("3.2.1"), :>, version("3.2beta4")
  end

  def test_comparing_unevenly_padded_versions
    assert_operator version("2.1.0-p194"), :<, version("2.1-p195")
    assert_operator version("2.1-p195"), :>, version("2.1.0-p194")
    assert_operator version("2.1-p194"), :<, version("2.1.0-p195")
    assert_operator version("2.1.0-p195"), :>, version("2.1-p194")
    assert_operator version("2-p194"), :<, version("2.1-p195")
  end

  def test_comparison_returns_nil_for_non_version
    v = version("1.0")
    assert_nil v <=> Object.new
    assert_raises(ArgumentError) { v > Object.new }
  end

  def test_compare_patchlevel_to_non_patchlevel
    assert_operator version("9.9.3-P1"), :>, version("9.9.3")
  end

  def test_erlang_version
    versions = %w[R16B R15B03-1 R15B03 R15B02 R15B01 R14B04 R14B03
                  R14B02 R14B01 R14B R13B04 R13B03 R13B02-1].reverse
    assert_equal versions, versions.sort_by { |v| version(v) }
  end

  def test_hash_equality
    v1 = version("0.1.0")
    v2 = version("0.1.0")
    v3 = version("0.1.1")

    assert_eql v1, v2
    refute_eql v1, v3
    assert_equal v1.hash, v2.hash

    h = { v1 => :foo }
    assert_equal :foo, h[v2]
  end
end

class VersionParsingTests < Homebrew::TestCase
  def test_pathname_version
    d = HOMEBREW_CELLAR/"foo-0.1.9"
    d.mkpath
    assert_equal version("0.1.9"), d.version
  ensure
    d.unlink
  end

  def test_no_version
    assert_version_nil "http://example.com/blah.tar"
    assert_version_nil "foo"
  end

  def test_version_all_dots
    assert_version_detected "1.14", "http://example.com/foo.bar.la.1.14.zip"
  end

  def test_version_underscore_separator
    assert_version_detected "1.1", "http://example.com/grc_1.1.tar.gz"
  end

  def test_boost_version_style
    assert_version_detected "1.39.0", "http://example.com/boost_1_39_0.tar.bz2"
  end

  def test_erlang_version_style
    assert_version_detected "R13B", "http://erlang.org/download/otp_src_R13B.tar.gz"
  end

  def test_another_erlang_version_style
    assert_version_detected "R15B01", "https://github.com/erlang/otp/tarball/OTP_R15B01"
  end

  def test_yet_another_erlang_version_style
    assert_version_detected "R15B03-1", "https://github.com/erlang/otp/tarball/OTP_R15B03-1"
  end

  def test_p7zip_version_style
    assert_version_detected "9.04",
      "http://kent.dl.sourceforge.net/sourceforge/p7zip/p7zip_9.04_src_all.tar.bz2"
  end

  def test_new_github_style
    assert_version_detected "1.1.4", "https://github.com/sam-github/libnet/tarball/libnet-1.1.4"
  end

  def test_gloox_beta_style
    assert_version_detected "1.0-beta7", "http://camaya.net/download/gloox-1.0-beta7.tar.bz2"
  end

  def test_sphinx_beta_style
    assert_version_detected "1.10-beta", "http://sphinxsearch.com/downloads/sphinx-1.10-beta.tar.gz"
  end

  def test_astyle_verson_style
    assert_version_detected "1.23", "http://kent.dl.sourceforge.net/sourceforge/astyle/astyle_1.23_macosx.tar.gz"
  end

  def test_version_dos2unix
    assert_version_detected "3.1", "http://www.sfr-fresh.com/linux/misc/dos2unix-3.1.tar.gz"
  end

  def test_version_internal_dash
    assert_version_detected "1.1-2", "http://example.com/foo-arse-1.1-2.tar.gz"
  end

  def test_version_single_digit
    assert_version_detected "45", "http://example.com/foo_bar.45.tar.gz"
  end

  def test_noseparator_single_digit
    assert_version_detected "45", "http://example.com/foo_bar45.tar.gz"
  end

  def test_version_developer_that_hates_us_format
    assert_version_detected "1.2.3", "http://example.com/foo-bar-la.1.2.3.tar.gz"
  end

  def test_version_regular
    assert_version_detected "1.21", "http://example.com/foo_bar-1.21.tar.gz"
  end

  def test_version_sourceforge_download
    assert_version_detected "1.21", "http://sourceforge.net/foo_bar-1.21.tar.gz/download"
    assert_version_detected "1.21", "http://sf.net/foo_bar-1.21.tar.gz/download"
  end

  def test_version_github
    assert_version_detected "1.0.5", "http://github.com/lloyd/yajl/tarball/1.0.5"
  end

  def test_version_github_with_high_patch_number
    assert_version_detected "1.2.34", "http://github.com/lloyd/yajl/tarball/v1.2.34"
  end

  def test_yet_another_version
    assert_version_detected "0.15.1b", "http://example.com/mad-0.15.1b.tar.gz"
  end

  def test_lame_version_style
    assert_version_detected "398-2", "http://kent.dl.sourceforge.net/sourceforge/lame/lame-398-2.tar.gz"
  end

  def test_ruby_version_style
    assert_version_detected "1.9.1-p243", "ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.1-p243.tar.gz"
  end

  def test_omega_version_style
    assert_version_detected "0.80.2", "http://www.alcyone.com/binaries/omega/omega-0.80.2-src.tar.gz"
  end

  def test_rc_style
    assert_version_detected "1.2.2rc1", "http://downloads.xiph.org/releases/vorbis/libvorbis-1.2.2rc1.tar.bz2"
  end

  def test_dash_rc_style
    assert_version_detected "1.8.0-rc1", "http://ftp.mozilla.org/pub/mozilla.org/js/js-1.8.0-rc1.tar.gz"
  end

  def test_angband_version_style
    assert_version_detected "3.0.9b", "http://rephial.org/downloads/3.0/angband-3.0.9b-src.tar.gz"
  end

  def test_stable_suffix
    assert_version_detected "1.4.14b", "http://www.monkey.org/~provos/libevent-1.4.14b-stable.tar.gz"
  end

  def test_debian_style_1
    assert_version_detected "3.03", "http://ftp.de.debian.org/debian/pool/main/s/sl/sl_3.03.orig.tar.gz"
  end

  def test_debian_style_2
    assert_version_detected "1.01b", "http://ftp.de.debian.org/debian/pool/main/m/mmv/mmv_1.01b.orig.tar.gz"
  end

  def test_bottle_style
    assert_version_detected "4.8.0", "https://homebrew.bintray.com/bottles/qt-4.8.0.lion.bottle.tar.gz"
  end

  def test_versioned_bottle_style
    assert_version_detected "4.8.1", "https://homebrew.bintray.com/bottles/qt-4.8.1.lion.bottle.1.tar.gz"
  end

  def test_erlang_bottle_style
    assert_version_detected "R15B", "https://homebrew.bintray.com/bottles/erlang-R15B.lion.bottle.tar.gz"
  end

  def test_another_erlang_bottle_style
    assert_version_detected "R15B01", "https://homebrew.bintray.com/bottles/erlang-R15B01.mountain_lion.bottle.tar.gz"
  end

  def test_yet_another_erlang_bottle_style
    assert_version_detected "R15B03-1", "https://homebrew.bintray.com/bottles/erlang-R15B03-1.mountainlion.bottle.tar.gz"
  end

  def test_imagemagick_style
    assert_version_detected "6.7.5-7", "http://downloads.sf.net/project/machomebrew/mirror/ImageMagick-6.7.5-7.tar.bz2"
  end

  def test_imagemagick_bottle_style
    assert_version_detected "6.7.5-7", "https://homebrew.bintray.com/bottles/imagemagick-6.7.5-7.lion.bottle.tar.gz"
  end

  def test_imagemagick_versioned_bottle_style
    assert_version_detected "6.7.5-7", "https://homebrew.bintray.com/bottles/imagemagick-6.7.5-7.lion.bottle.1.tar.gz"
  end

  def test_dash_version_dash_style
    assert_version_detected "3.4", "http://www.antlr.org/download/antlr-3.4-complete.jar"
  end

  def test_jenkins_version_style
    assert_version_detected "1.486", "http://mirrors.jenkins-ci.org/war/1.486/jenkins.war"
  end

  def test_apache_version_style
    assert_version_detected "1.2.0-rc2", "http://www.apache.org/dyn/closer.cgi?path=/cassandra/1.2.0/apache-cassandra-1.2.0-rc2-bin.tar.gz"
  end

  def test_jpeg_style
    assert_version_detected "8d", "http://www.ijg.org/files/jpegsrc.v8d.tar.gz"
  end

  def test_version_ghc_style
    assert_version_detected "7.0.4", "http://www.haskell.org/ghc/dist/7.0.4/ghc-7.0.4-x86_64-apple-darwin.tar.bz2"
    assert_version_detected "7.0.4", "http://www.haskell.org/ghc/dist/7.0.4/ghc-7.0.4-i386-apple-darwin.tar.bz2"
  end

  def test_pypy_version
    assert_version_detected "1.4.1", "http://pypy.org/download/pypy-1.4.1-osx.tar.bz2"
  end

  def test_openssl_version
    assert_version_detected "0.9.8s", "http://www.openssl.org/source/openssl-0.9.8s.tar.gz"
  end

  def test_xaw3d_version
    assert_version_detected "1.5E", "ftp://ftp.visi.com/users/hawkeyd/X/Xaw3d-1.5E.tar.gz"
  end

  def test_assimp_version
    assert_version_detected "2.0.863", "http://downloads.sourceforge.net/project/assimp/assimp-2.0/assimp--2.0.863-sdk.zip"
  end

  def test_cmucl_version
    assert_version_detected "20c", "http://common-lisp.net/project/cmucl/downloads/release/20c/cmucl-20c-x86-darwin.tar.bz2"
  end

  def test_fann_version
    assert_version_detected "2.1.0beta", "http://downloads.sourceforge.net/project/fann/fann/2.1.0beta/fann-2.1.0beta.zip"
  end

  def test_grads_version
    assert_version_detected "2.0.1", "ftp://iges.org/grads/2.0/grads-2.0.1-bin-darwin9.8-intel.tar.gz"
  end

  def test_haxe_version
    assert_version_detected "2.08", "http://haxe.org/file/haxe-2.08-osx.tar.gz"
  end

  def test_imap_version
    assert_version_detected "2007f", "ftp://ftp.cac.washington.edu/imap/imap-2007f.tar.gz"
  end

  def test_suite3270_version
    assert_version_detected "3.3.12ga7", "http://downloads.sourceforge.net/project/x3270/x3270/3.3.12ga7/suite3270-3.3.12ga7-src.tgz"
  end

  def test_wwwoffle_version
    assert_version_detected "2.9h", "http://www.gedanken.demon.co.uk/download-wwwoffle/wwwoffle-2.9h.tgz"
  end

  def test_synergy_version
    assert_version_detected "1.3.6p2", "http://synergy.googlecode.com/files/synergy-1.3.6p2-MacOSX-Universal.zip"
  end

  def test_fontforge_version
    assert_version_detected "20120731", "http://downloads.sourceforge.net/project/fontforge/fontforge-source/fontforge_full-20120731-b.tar.bz2"
  end

  def test_ezlupdate_version
    assert_version_detected "2011.10", "https://github.com/downloads/ezsystems/ezpublish-legacy/ezpublish_community_project-2011.10-with_ezc.tar.bz2"
  end

  def test_aespipe_version_style
    assert_version_detected "2.4c",
      "http://loop-aes.sourceforge.net/aespipe/aespipe-v2.4c.tar.bz2"
  end

  def test_win_style
    assert_version_detected "0.9.17",
      "http://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.17-w32.zip"
    assert_version_detected "1.29",
      "http://ftpmirror.gnu.org/libidn/libidn-1.29-win64.zip"
  end

  def test_with_arch
    assert_version_detected "4.0.18-1",
      "http://ftpmirror.gnu.org/mtools/mtools-4.0.18-1.i686.rpm"
    assert_version_detected "5.5.7-5",
      "http://ftpmirror.gnu.org/autogen/autogen-5.5.7-5.i386.rpm"
    assert_version_detected "2.8",
      "http://ftpmirror.gnu.org/libtasn1/libtasn1-2.8-x86.zip"
    assert_version_detected "2.8",
      "http://ftpmirror.gnu.org/libtasn1/libtasn1-2.8-x64.zip"
    assert_version_detected "4.0.18",
      "http://ftpmirror.gnu.org/mtools/mtools_4.0.18_i386.deb"
  end
end

class VersionTests < Test::Unit::TestCase
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
  
  def test_version_dos2unix
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

  def test_version_github_with_high_patch_number
    r=MockFormula.new "http://github.com/lloyd/yajl/tarball/v1.2.34"
    assert_equal '1.2.34', r.version
  end

  def test_yet_another_version
    r=MockFormula.new "http://example.com/mad-0.15.1b.tar.gz"
    assert_equal '0.15.1b', r.version
  end

  def test_lame_version_style
    f=MockFormula.new 'http://kent.dl.sourceforge.net/sourceforge/lame/lame-398-2.tar.gz'
    assert_equal '398-2', f.version
  end
  
  def test_ruby_version_style
    f=MockFormula.new 'ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.1-p243.tar.gz'
    assert_equal '1.9.1-p243', f.version
  end
  
  def test_omega_version_style
    f=MockFormula.new 'http://www.alcyone.com/binaries/omega/omega-0.80.2-src.tar.gz'
    assert_equal '0.80.2', f.version
  end

  def test_version_style_rc
    f=MockFormula.new 'http://ftp.mozilla.org/pub/mozilla.org/js/js-1.8.0-rc1.tar.gz'
    assert_equal '1.8.0-rc1', f.version
  end
  
  def test_angband_version_style
    f = MockFormula.new 'http://rephial.org/downloads/3.0/angband-3.0.9b-src.tar.gz'
    assert_equal '3.0.9b', f.version
  end
end

require "testing_env"
require "blacklist"

class BlacklistTests < Homebrew::TestCase
  def assert_blacklisted(s)
    assert blacklisted?(s), "'#{s}' should be blacklisted"
  end

  def test_rubygems
    %w[gem rubygem rubygems].each { |s| assert_blacklisted s }
  end

  def test_latex
    %w[latex tex tex-live texlive TexLive].each { |s| assert_blacklisted s }
  end

  def test_pip
    assert_blacklisted "pip"
  end

  def test_pil
    assert_blacklisted "pil"
  end

  def test_macruby
    assert_blacklisted "MacRuby"
  end

  def test_lzma
    %w[lzma liblzma].each { |s| assert_blacklisted s }
  end

  def test_xcode
    %w[xcode Xcode].each { |s| assert_blacklisted s }
  end

  def test_gtest
    %w[gtest googletest google-test].each { |s| assert_blacklisted s }
  end

  def test_gmock
    %w[gmock googlemock google-mock].each { |s| assert_blacklisted s }
  end

  def test_sshpass
    assert_blacklisted "sshpass"
  end

  def test_gsutil
    assert_blacklisted "gsutil"
  end

  def test_clojure
    assert_blacklisted "clojure"
  end

  def test_osmium
    %w[osmium Osmium].each { |s| assert_blacklisted s }
  end

  def test_gfortran
    assert_blacklisted "gfortran"
  end

  def test_play
    assert_blacklisted "play"
  end

  def test_haskell_platform
    assert_blacklisted "haskell-platform"
  end
end

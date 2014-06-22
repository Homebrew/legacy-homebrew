require 'testing_env'
require 'pkg_version'

class PkgVersionTests < Homebrew::TestCase
  def v(version)
    PkgVersion.parse(version)
  end

  def test_parse
    assert_equal PkgVersion.new("1.0", 1), PkgVersion.parse("1.0_1")
    assert_equal PkgVersion.new("1.0", 1), PkgVersion.parse("1.0_1")
    assert_equal PkgVersion.new("1.0", 0), PkgVersion.parse("1.0")
    assert_equal PkgVersion.new("1.0", 0), PkgVersion.parse("1.0_0")
    assert_equal PkgVersion.new("2.1.4", 0), PkgVersion.parse("2.1.4_0")
    assert_equal PkgVersion.new("2.1.4_1", 0), PkgVersion.parse("2.1.4_1_0")
    assert_equal PkgVersion.new("1.0.1e", 1), PkgVersion.parse("1.0.1e_1")
  end

  def test_comparison
    assert_operator v("1.0_0"), :==, v("1.0")
    assert_operator v("1.0_1"), :==, v("1.0_1")
    assert_operator v("1.1"), :>, v("1.0_1")
    assert_operator v("1.0_0"), :==, v("1.0")
    assert_operator v("1.0_1"), :<, v("2.0_1")
    assert_operator v("HEAD"), :>, v("1.0")
    assert_operator v("1.0"), :<, v("HEAD")
  end

  def test_to_s
    assert_equal "1.0", PkgVersion.new("1.0", 0).to_s
    assert_equal "1.0_1", PkgVersion.new("1.0", 1).to_s
    assert_equal "1.0", PkgVersion.new("1.0", 0).to_s
    assert_equal "1.0", PkgVersion.new("1.0", 0).to_s
    assert_equal "HEAD", PkgVersion.new("HEAD", 1).to_s
  end
end

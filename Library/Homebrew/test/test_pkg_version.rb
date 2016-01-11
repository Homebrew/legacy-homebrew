require "testing_env"
require "pkg_version"

class PkgVersionTests < Homebrew::TestCase
  def v(version)
    PkgVersion.parse(version)
  end

  def test_parse
    assert_equal PkgVersion.new(Version.new("1.0"), 1), PkgVersion.parse("1.0_1")
    assert_equal PkgVersion.new(Version.new("1.0"), 1), PkgVersion.parse("1.0_1")
    assert_equal PkgVersion.new(Version.new("1.0"), 0), PkgVersion.parse("1.0")
    assert_equal PkgVersion.new(Version.new("1.0"), 0), PkgVersion.parse("1.0_0")
    assert_equal PkgVersion.new(Version.new("2.1.4"), 0), PkgVersion.parse("2.1.4_0")
    assert_equal PkgVersion.new(Version.new("1.0.1e"), 1), PkgVersion.parse("1.0.1e_1")
  end

  def test_comparison
    assert_operator v("1.0_0"), :==, v("1.0")
    assert_operator v("1.0_1"), :==, v("1.0_1")
    assert_operator v("1.1"), :>, v("1.0_1")
    assert_operator v("1.0_0"), :==, v("1.0")
    assert_operator v("1.0_1"), :<, v("2.0_1")
    assert_operator v("HEAD"), :>, v("1.0")
    assert_operator v("1.0"), :<, v("HEAD")

    v = PkgVersion.new(Version.new("1.0"), 0)
    assert_nil v <=> Object.new
    assert_raises(ArgumentError) { v > Object.new }
    assert_raises(ArgumentError) { v > Version.new("1.0") }
  end

  def test_to_s
    assert_equal "1.0", PkgVersion.new(Version.new("1.0"), 0).to_s
    assert_equal "1.0_1", PkgVersion.new(Version.new("1.0"), 1).to_s
    assert_equal "1.0", PkgVersion.new(Version.new("1.0"), 0).to_s
    assert_equal "1.0", PkgVersion.new(Version.new("1.0"), 0).to_s
    assert_equal "HEAD", PkgVersion.new(Version.new("HEAD"), 1).to_s
  end

  def test_hash
    p1 = PkgVersion.new(Version.new("1.0"), 1)
    p2 = PkgVersion.new(Version.new("1.0"), 1)
    p3 = PkgVersion.new(Version.new("1.1"), 1)
    p4 = PkgVersion.new(Version.new("1.0"), 0)
    assert_equal p1.hash, p2.hash
    refute_equal p1.hash, p3.hash
    refute_equal p1.hash, p4.hash
  end
end

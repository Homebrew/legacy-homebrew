require "testing_env"
require "requirements/x11_requirement"

class X11RequirementTests < Homebrew::TestCase
  def test_eql_instances_are_eql
    x = X11Requirement.new
    y = X11Requirement.new
    assert_eql x, y
    assert_equal x.hash, y.hash
  end

  def test_not_eql_when_hashes_differ
    x = X11Requirement.new("foo")
    y = X11Requirement.new
    refute_eql x, y
    refute_equal x.hash, y.hash
  end

  def test_different_min_version
    x = X11Requirement.new
    y = X11Requirement.new("x11", %w[2.5])
    refute_eql x, y
  end

  def test_x_env
    x = X11Requirement.new
    x.stubs(:satisfied?).returns(true)
    ENV.expects(:x11)
    x.modify_build_environment
  end

  def test_satisfied
    MacOS::XQuartz.stubs(:version).returns("2.7.5")
    MacOS::XQuartz.stubs(:installed?).returns(true)
    assert_predicate X11Requirement.new, :satisfied?

    MacOS::XQuartz.stubs(:installed?).returns(false)
    refute_predicate X11Requirement.new, :satisfied?
  end
end

require 'testing_env'
require 'extend/set'
require 'requirements/x11_dependency'

class X11DependencyTests < Homebrew::TestCase
  def test_eql_instances_are_eql
    x = X11Dependency.new
    y = X11Dependency.new
    assert x.eql?(y)
    assert y.eql?(x)
    assert_equal x.hash, y.hash
  end

  def test_not_eql_when_hashes_differ
    x = X11Dependency.new("foo")
    y = X11Dependency.new
    refute_equal x.hash, y.hash
    assert !x.eql?(y)
    assert !y.eql?(x)
  end

  def test_different_min_version
    x = X11Dependency.new
    y = X11Dependency.new("x11", %w[2.5])
    refute x.eql?(y)
    refute y.eql?(x)
  end

  def test_x_env
    x = X11Dependency.new
    x.stubs(:satisfied?).returns(true)
    ENV.expects(:x11)
    x.modify_build_environment
  end

  def test_satisfied
    MacOS::XQuartz.stubs(:version).returns("2.7.5")
    MacOS::XQuartz.stubs(:installed?).returns(true)
    assert_predicate X11Dependency.new, :satisfied?

    MacOS::XQuartz.stubs(:installed?).returns(false)
    refute_predicate X11Dependency.new, :satisfied?
  end
end

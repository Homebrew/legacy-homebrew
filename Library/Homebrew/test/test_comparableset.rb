require 'testing_env'
require 'extend/set'
require 'requirements'

class ComparableSetTests < Test::Unit::TestCase
  def setup
    @set = ComparableSet.new
  end

  def test_merging_multiple_dependencies
    @set << X11Dependency.new
    @set << X11Dependency.new
    assert_equal @set.count, 1
    @set << Requirement.new
    assert_equal @set.count, 2
  end

  def test_comparison_prefers_larger
    @set << X11Dependency.new
    @set << X11Dependency.new('x11', '2.6')
    assert_equal @set.count, 1
    assert_equal @set.to_a, [X11Dependency.new('x11', '2.6')]
  end

  def test_comparison_does_not_merge_smaller
    @set << X11Dependency.new('x11', '2.6')
    @set << X11Dependency.new
    assert_equal @set.count, 1
    assert_equal @set.to_a, [X11Dependency.new('x11', '2.6')]
  end

  def test_merging_sets
    @set << X11Dependency.new
    @set << Requirement.new
    reqs = Set.new [X11Dependency.new('x11', '2.6'), Requirement.new]
    assert_same @set, @set.merge(reqs)

    assert_equal @set.count, 2
    assert_equal @set.find {|r| r.is_a? X11Dependency}, X11Dependency.new('x11', '2.6')
  end
end

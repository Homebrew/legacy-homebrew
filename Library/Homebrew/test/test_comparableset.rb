require 'testing_env'
require 'extend/set'
require 'requirements'

class ComparableSetTests < Homebrew::TestCase
  def setup
    @set = ComparableSet.new
  end

  def test_merging_multiple_dependencies
    @set << X11Dependency.new
    @set << X11Dependency.new
    assert_equal 1, @set.count
    @set << Requirement.new
    assert_equal 2, @set.count
  end

  def test_comparison_prefers_larger
    @set << X11Dependency.new
    @set << X11Dependency.new('x11', %w{2.6})
    assert_equal 1, @set.count
    assert_equal [X11Dependency.new('x11', %w{2.6})], @set.to_a
  end

  def test_comparison_does_not_merge_smaller
    @set << X11Dependency.new('x11', %w{2.6})
    @set << X11Dependency.new
    assert_equal 1, @set.count
    assert_equal [X11Dependency.new('x11', %w{2.6})], @set.to_a
  end

  def test_merging_sets
    @set << X11Dependency.new
    @set << Requirement.new
    reqs = Set.new [X11Dependency.new('x11', %w{2.6}), Requirement.new]
    assert_same @set, @set.merge(reqs)

    assert_equal 2, @set.count
    assert_equal X11Dependency.new('x11', %w{2.6}), @set.find {|r| r.is_a? X11Dependency}
  end
end

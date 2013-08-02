require 'testing_env'
require 'dependency'

class DependencyExpansionTests < Test::Unit::TestCase
  def build_dep(name, tags=[], deps=[])
    dep = Dependency.new(name.to_s, tags)
    dep.stubs(:to_formula).returns(stub(:deps => deps))
    dep
  end

  def setup
    @foo = build_dep(:foo)
    @bar = build_dep(:bar)
    @baz = build_dep(:baz)
    @qux = build_dep(:qux)
    @deps = [@foo, @bar, @baz, @qux]
    @f    = stub(:deps => @deps)
  end

  def test_expand_yields_dependent_and_dep_pairs
    i = 0
    Dependency.expand(@f) do |dependent, dep|
      assert_equal @f, dependent
      assert_equal dep, @deps[i]
      i += 1
    end
  end

  def test_expand_no_block
    assert_equal @deps, Dependency.expand(@f)
  end

  def test_expand_prune_all
    assert_empty Dependency.expand(@f) { Dependency.prune }
  end

  def test_expand_selective_pruning
    deps = Dependency.expand(@f) do |_, dep|
      Dependency.prune if dep.name == 'foo'
    end

    assert_equal [@bar, @baz, @qux], deps
  end

  def test_expand_preserves_dependency_order
    @foo.stubs(:to_formula).returns(stub(:deps => [@qux, @baz]))
    assert_equal [@qux, @baz, @foo, @bar], Dependency.expand(@f)
  end

  def test_expand_skips_optionals_by_default
    @foo.expects(:optional?).returns(true)
    @f = stub(:deps => @deps, :build => stub(:with? => false))
    assert_equal [@bar, @baz, @qux], Dependency.expand(@f)
  end

  def test_expand_keeps_recommendeds_by_default
    @foo.expects(:recommended?).returns(true)
    @f = stub(:deps => @deps, :build => stub(:with? => true))
    assert_equal @deps, Dependency.expand(@f)
  end

  def test_merges_repeated_deps_with_differing_options
    @foo2 = build_dep(:foo, ['option'])
    @baz2 = build_dep(:baz, ['option'])
    @deps << @foo2 << @baz2
    deps = [@foo2, @bar, @baz2, @qux]
    deps.zip(Dependency.expand(@f)) do |expected, actual|
      assert_equal expected.tags, actual.tags
      assert_equal expected, actual
    end
  end

  def test_merger_preserves_env_proc
    env_proc = @foo.env_proc = stub
    assert_equal env_proc, Dependency.expand(@f).first.env_proc
  end

  def test_merged_tags_no_dupes
    @foo2 = build_dep(:foo, ['option'])
    @foo3 = build_dep(:foo, ['option'])
    @deps << @foo2 << @foo3

    assert_equal %w{option}, Dependency.expand(@f).first.tags
  end

  def test_skip_skips_parent_but_yields_children
    f = stub(:deps => [
      build_dep(:foo, [], [@bar, @baz]),
      build_dep(:foo, [], [@baz]),
    ])

    deps = Dependency.expand(f) do |dependent, dep|
      Dependency.skip if %w{foo qux}.include? dep.name
    end

    assert_equal [@bar, @baz], deps
  end
end

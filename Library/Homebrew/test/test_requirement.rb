require 'testing_env'
require 'requirement'

class RequirementTests < Test::Unit::TestCase
  def test_accepts_single_tag
    dep = Requirement.new(%w{bar})
    assert_equal %w{bar}, dep.tags
  end

  def test_accepts_multiple_tags
    dep = Requirement.new(%w{bar baz})
    assert_equal %w{bar baz}.sort, dep.tags.sort
  end

  def test_preserves_symbol_tags
    dep = Requirement.new([:build])
    assert_equal [:build], dep.tags
  end

  def test_accepts_symbol_and_string_tags
    dep = Requirement.new([:build, "bar"])
    assert_equal [:build, "bar"], dep.tags
  end

  def test_dsl_fatal
    req = Class.new(Requirement) { fatal true }.new
    assert req.fatal?
  end

  def test_satisfy_true
    req = Class.new(Requirement) do
      satisfy(:build_env => false) { true }
    end.new
    assert req.satisfied?
  end

  def test_satisfy_false
    req = Class.new(Requirement) do
      satisfy(:build_env => false) { false }
    end.new
    assert !req.satisfied?
  end

  def test_satisfy_with_boolean
    req = Class.new(Requirement) do
      satisfy true
    end.new
    assert req.satisfied?
  end

  def test_satisfy_sets_up_build_env_by_default
    req = Class.new(Requirement) do
      satisfy { true }
    end.new

    ENV.expects(:with_build_environment).yields.returns(true)

    assert req.satisfied?
  end

  def test_satisfy_build_env_can_be_disabled
    req = Class.new(Requirement) do
      satisfy(:build_env => false) { true }
    end.new

    ENV.expects(:with_build_environment).never

    assert req.satisfied?
  end

  def test_infers_path_from_satisfy_result
    which_path = Pathname.new("/foo/bar/baz")
    req = Class.new(Requirement) do
      satisfy { which_path }
    end.new

    ENV.expects(:with_build_environment).yields.returns(which_path)
    ENV.expects(:append_path).with("PATH", which_path.parent)

    req.satisfied?
    req.modify_build_environment
  end

  def test_dsl_build
    req = Class.new(Requirement) { build true }.new
    assert req.build?
  end

  def test_infer_name_from_class
    klass, const = self.class, :FooRequirement
    klass.const_set(const, Class.new(Requirement))
    assert_equal "foo", klass.const_get(const).new.name
  ensure
    klass.send(:remove_const, const) if klass.const_defined?(const)
  end

  def test_dsl_default_formula
    req = Class.new(Requirement) { default_formula 'foo' }.new
    assert req.default_formula?
  end

  def test_to_dependency
    req = Class.new(Requirement) { default_formula 'foo' }.new
    assert_equal Dependency.new('foo'), req.to_dependency
  end

  def test_to_dependency_calls_requirement_modify_build_environment
    error = Class.new(StandardError)

    req = Class.new(Requirement) do
      default_formula 'foo'
      satisfy { true }
      env { raise error }
    end.new

    assert_raises(error) do
      req.to_dependency.modify_build_environment
    end
  end

  def test_eql
    a, b = Requirement.new, Requirement.new
    assert a.eql?(b)
    assert b.eql?(a)
    assert_equal a.hash, b.hash
  end

  def test_not_eql
    a, b = Requirement.new([:optional]), Requirement.new
    assert_not_equal a.hash, b.hash
    assert !a.eql?(b)
    assert !b.eql?(a)
  end
end

require 'testing_env'
require 'requirement'

class RequirementTests < Test::Unit::TestCase
  def test_accepts_single_tag
    dep = Requirement.new("bar")
    assert_equal %w{bar}, dep.tags
  end

  def test_accepts_multiple_tags
    dep = Requirement.new(%w{bar baz})
    assert_equal %w{bar baz}.sort, dep.tags.sort
    dep = Requirement.new(*%w{bar baz})
    assert_equal %w{bar baz}.sort, dep.tags.sort
  end

  def test_preserves_symbol_tags
    dep = Requirement.new(:build)
    assert_equal [:build], dep.tags
  end

  def test_accepts_symbol_and_string_tags
    dep = Requirement.new([:build, "bar"])
    assert_equal [:build, "bar"], dep.tags
    dep = Requirement.new(:build, "bar")
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
      env :userpaths
      satisfy { true }
    end.new

    ENV.expects(:with_build_environment).yields.returns(true)
    ENV.expects(:userpaths!)

    assert req.satisfied?
  end

  def test_satisfy_build_env_can_be_disabled
    req = Class.new(Requirement) do
      satisfy(:build_env => false) { true }
    end.new

    ENV.expects(:with_build_environment).never
    ENV.expects(:userpaths!).never

    assert req.satisfied?
  end

  def test_infers_path_from_satisfy_result
    which_path = Pathname.new("/foo/bar/baz")
    req = Class.new(Requirement) do
      satisfy { which_path }
    end.new

    ENV.expects(:with_build_environment).yields.returns(which_path)
    ENV.expects(:userpaths!)
    ENV.expects(:append).with("PATH", which_path.parent, ":")

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
end

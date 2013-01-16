require 'testing_env'
require 'dependencies'

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

  def test_dsl_env_single_argument
    req = Class.new(Requirement) { env :userpaths }.new
    assert req.env.userpaths?
  end

  def test_dsl_env_multiple_arguments
    req = Class.new(Requirement) { env :userpaths, :std }.new
    assert req.env.userpaths?
    assert req.env.std?
  end

  def test_dsl_fatal
    req = Class.new(Requirement) { fatal true }.new
    assert req.fatal?
  end
end

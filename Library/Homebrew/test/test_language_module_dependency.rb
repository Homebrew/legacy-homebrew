require 'testing_env'
require 'requirements/language_module_dependency'

class LanguageModuleDependencyTests < Homebrew::TestCase
  def assert_deps_fail(spec)
    refute_predicate LanguageModuleDependency.new(*spec.shift.reverse), :satisfied?
  end

  def assert_deps_pass(spec)
    assert_predicate LanguageModuleDependency.new(*spec.shift.reverse), :satisfied?
  end

  def test_unique_deps_are_not_eql
    x = LanguageModuleDependency.new(:node, "less")
    y = LanguageModuleDependency.new(:node, "coffee-script")
    refute_equal x.hash, y.hash
    assert !x.eql?(y)
    assert !y.eql?(x)
  end

  def test_differing_module_and_import_name
    mod_name = "foo"
    import_name = "bar"
    l = LanguageModuleDependency.new(:python, mod_name, import_name)
    assert_includes l.message, mod_name
    assert l.the_test.one? { |c| c.include?(import_name) }
  end

  def test_bad_perl_deps
    assert_deps_fail "notapackage" => :perl
  end

  def test_good_perl_deps
    assert_deps_pass "ENV" => :perl
  end

  def test_bad_python_deps
    assert_deps_fail "notapackage" => :python
  end

  def test_good_python_deps
    assert_deps_pass "datetime" => :python
  end

  def test_bad_ruby_deps
    assert_deps_fail "notapackage" => :ruby
  end

  def test_good_ruby_deps
    assert_deps_pass "date" => :ruby
  end

  if which("rbx")
    def test_bad_rubinius_deps
      assert_deps_fail "notapackage" => :rbx
    end

    def test_good_rubinius_deps
      assert_deps_pass "date" => :rbx
    end
  end

  if which("csc")
    def test_bad_chicken_deps
      assert_deps_fail "notapackage" => :chicken
    end

    def test_good_chicken_deps
      assert_deps_pass "extras" => :chicken
    end
  end

  if which("node")
    def test_bad_node_deps
      assert_deps_fail "notapackage" => :node
    end

    def test_good_node_deps
      assert_deps_pass "util" => :node
    end
  end
end

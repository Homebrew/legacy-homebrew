require 'testing_env'
require 'extend/string'
require 'test/testball'
require 'formula_installer'


class ExternalDepsTests < Test::Unit::TestCase
  def check_deps_fail specs
    d = DependencyCollector.new
    specs.each do |key, value|
      d.add key => value
    end

    # Should have found a dep
    assert d.external_deps.size == 1

    d.external_deps do |dep|
      assert !d.satisfied?
    end
  end

  def check_deps_pass specs
    d = DependencyCollector.new
    specs.each do |key, value|
      d.add key => value
    end

    # Should have found a dep
    assert d.external_deps.size == 1

    d.external_deps do |dep|
      assert d.satisfied?
    end
  end


  def test_bad_perl_deps
    check_deps_fail "notapackage" => :perl
  end

  def test_good_perl_deps
    check_deps_pass "ENV" => :perl
  end

  def test_bad_python_deps
    check_deps_fail "notapackage" => :python
  end

  def test_good_python_deps
    check_deps_pass "datetime" => :python
  end

  def test_bad_ruby_deps
    check_deps_fail "notapackage" => :ruby
  end

  def test_good_ruby_deps
    check_deps_pass "date" => :ruby
  end

  # Only run these next two tests if jruby is installed.
  def test_bad_jruby_deps
    check_deps_fail "notapackage" => :jruby if which('jruby')
  end

  def test_good_jruby_deps
    check_deps_pass "date" => :jruby if which('jruby')
  end

  # Only run these next two tests if rubinius is installed.
  def test_bad_rubinius_deps
    check_deps_fail "notapackage" => :rbx if which('rbx')
  end

  def test_good_rubinius_deps
    check_deps_pass "date" => :rbx if which('rbx')
  end

  # Only run these next two tests if chicken scheme is installed.
  def test_bad_chicken_deps
    check_deps_fail "notapackage" => :chicken if which('csc')
  end

  def test_good_chicken_deps
    check_deps_pass "extras" => :chicken if which('csc')
  end

  # Only run these next two tests if node.js is installed.
  def test_bad_node_deps
    check_deps_fail "notapackage" => :node if which('node')
  end

  def test_good_node_deps
    check_deps_pass "util" => :node if which('node')
  end
end

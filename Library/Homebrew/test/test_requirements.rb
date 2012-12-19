require 'testing_env'
require 'test/testball'
require 'dependencies'

class DependencyCollector
  def find_requirement(klass)
    requirements.find do |req|
      klass === req
    end
  end
end

class RequirementTests < Test::Unit::TestCase
  def setup
    @d = DependencyCollector.new
  end

  def test_requirement_creation
    @d.add :x11
    assert_not_nil @d.find_requirement(X11Dependency)
  end


  def test_no_duplicate_requirements
    2.times { @d.add :x11 }
    assert_equal 1, @d.requirements.length
  end
end

class RequirementTagTests < Test::Unit::TestCase
  def setup
    @d = DependencyCollector.new
  end

  def test_requirement_tags
    @d.add :x11 => '2.5.1'
    @d.add :xcode => :build
    assert_empty @d.find_requirement(X11Dependency).tags
    assert @d.find_requirement(XcodeDependency).build?
  end

  def test_x11_no_tag
    @d.add :x11
    assert_empty @d.find_requirement(X11Dependency).tags
  end

  def test_x11_min_version
    @d.add :x11 => '2.5.1'
    assert_equal '2.5.1', @d.find_requirement(X11Dependency).min_version
  end

  def test_x11_tag
    @d.add :x11 => :optional
    assert @d.find_requirement(X11Dependency).optional?
  end

  def test_x11_min_version_and_tag
    @d.add :x11 => ['2.5.1', :optional]
    dep = @d.find_requirement(X11Dependency)
    assert_equal '2.5.1', dep.min_version
    assert dep.optional?
  end
end

class ExternalDepsTests < Test::Unit::TestCase
  def check_deps_fail specs
    d = DependencyCollector.new
    specs.each do |key, value|
      d.add key => value
    end

    # Should have found a dep
    assert d.requirements.size == 1

    d.requirements do |req|
      assert !d.satisfied?
    end
  end

  def check_deps_pass specs
    d = DependencyCollector.new
    specs.each do |key, value|
      d.add key => value
    end

    # Should have found a dep
    assert d.requirements.size == 1

    d.requirements do |req|
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

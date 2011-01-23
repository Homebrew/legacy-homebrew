require 'testing_env'

require 'extend/ARGV' # needs to be after test/unit to avoid conflict with OptionsParser
ARGV.extend(HomebrewArgvExtension)

require 'extend/string'
require 'test/testball'
require 'formula_installer'
require 'utils'


class BadPerlBall <TestBall
  depends_on "notapackage" => :perl

  def initialize name=nil
    super "uses_perl_ball"
  end
end

class GoodPerlBall <TestBall
  depends_on "ENV" => :perl

  def initialize name=nil
    super "uses_perl_ball"
  end
end

class BadPythonBall <TestBall
  depends_on "notapackage" => :python

  def initialize name=nil
    super "uses_python_ball"
  end
end

class GoodPythonBall <TestBall
  depends_on "datetime" => :python

  def initialize name=nil
    super "uses_python_ball"
  end
end

class BadRubyBall <TestBall
  depends_on "notapackage" => :ruby

  def initialize name=nil
    super "uses_ruby_ball"
  end
end

class GoodRubyBall <TestBall
  depends_on "date" => :ruby

  def initialize name=nil
    super "uses_ruby_ball"
  end
end

class BadJRubyBall <TestBall
  depends_on "notapackage" => :jruby

  def initialize name=nil
    super "uses_jruby_ball"
  end
end

class GoodJRubyBall <TestBall
  depends_on "date" => :jruby

  def initialize name=nil
    super "uses_jruby_ball"
  end
end


class ExternalDepsTests < Test::Unit::TestCase
  def check_deps_fail f
    assert_raises(UnsatisfiedExternalDependencyError) do
      FormulaInstaller.check_external_deps f.new
    end
  end

  def check_deps_pass f
    assert_nothing_raised do
      FormulaInstaller.check_external_deps f.new
    end
  end


  def test_bad_perl_deps
    check_deps_fail BadPerlBall
  end

  def test_good_perl_deps
    check_deps_pass GoodPerlBall
  end

  def test_bad_python_deps
    check_deps_fail BadPythonBall
  end

  def test_good_python_deps
    check_deps_pass GoodPythonBall
  end

  def test_bad_ruby_deps
    check_deps_fail BadRubyBall
  end

  def test_good_ruby_deps
    check_deps_pass GoodRubyBall
  end

  # Only run these next two tests if jruby is installed.
  def test_bad_jruby_deps
    check_deps_fail BadJRubyBall unless `/usr/bin/which jruby`.chomp.empty?
  end

  def test_good_jruby_deps
    check_deps_pass GoodJRubyBall unless `/usr/bin/which jruby`.chomp.empty?
  end
end

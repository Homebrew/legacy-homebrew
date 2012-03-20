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

class BadChickenBall <TestBall
  depends_on "notapackage" => :chicken

  def initialize name=nil
    super "uses_chicken_ball"
  end
end

class GoodChickenBall <TestBall
  depends_on "extras" => :chicken

  def initialize name=nil
    super "uses_chicken_ball"
  end
end

class BadRubiniusBall <TestBall
  depends_on "notapackage" => :rbx

  def initialize name=nil
    super "uses_rubinius_ball"
  end
end

class GoodRubiniusBall <TestBall
  depends_on "date" => :rbx

  def intialize
    super "uses_rubinius_ball"
  end
end

class BadNodeBall <TestBall
  depends_on "notapackage" => :node

  def initialize
    super "uses_node_ball"
  end
end

class GoodNodeBall <TestBall
  depends_on "util" => :node

  def initialize
    super "uses_node_balls"
  end
end


class ExternalDepsTests < Test::Unit::TestCase
  def check_deps_fail f
    assert_raises(UnsatisfiedRequirement) do
      f.new.external_deps.each do |dep|
        raise UnsatisfiedRequirement.new(f, dep) unless dep.satisfied?
      end
    end
  end

  def check_deps_pass f
    assert_nothing_raised do
      f.new.external_deps.each do |dep|
        raise UnsatisfiedRequirement.new(f, dep) unless dep.satisfied?
      end
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

  # Only run these next two tests if rubinius is installed.
  def test_bad_rubinius_deps
    check_deps_fail BadRubiniusBall unless `/usr/bin/which rbx`.chomp.empty?
  end

  def test_good_rubinius_deps
    check_deps_pass GoodRubiniusBall unless `/usr/bin/which rbx`.chomp.empty?
  end

  # Only run these next two tests if chicken scheme is installed.
  def test_bad_chicken_deps
    check_deps_fail BadChickenBall unless `/usr/bin/which csc`.chomp.empty?
  end

  def test_good_chicken_deps
    check_deps_pass GoodChickenBall unless `/usr/bin/which csc`.chomp.empty?
  end

  # Only run these next two tests if node.js is installed.
  def test_bad_node_deps
    check_deps_fail BadNodeBall unless `/usr/bin/which node`.chomp.empty?
  end

  def test_good_node_deps
    check_deps_pass GoodNodeBall unless `/usr/bin/which node`.chomp.empty?
  end
end

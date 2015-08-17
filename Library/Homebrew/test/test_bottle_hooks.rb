require "testing_env"
require "formula_installer"
require "hooks/bottles"

class BottleHookTests < Homebrew::TestCase
  class FormulaDouble
    def bottle; end
    def local_bottle_path; end

    def some_random_method
      true
    end

    def file_modified?; end
  end

  def setup
    @fi = FormulaInstaller.new FormulaDouble.new
  end

  def test_has_bottle
    Homebrew::Hooks::Bottles.setup_formula_has_bottle(&:some_random_method)
    assert_predicate @fi, :pour_bottle?
  end

  def test_has_no_bottle
    Homebrew::Hooks::Bottles.setup_formula_has_bottle do |f|
      !f.some_random_method
    end
    refute_predicate @fi, :pour_bottle?
  end

  def test_pour_formula_bottle
    Homebrew::Hooks::Bottles.setup_formula_has_bottle do |_f|
      true
    end

    Homebrew::Hooks::Bottles.setup_pour_formula_bottle(&:some_random_method)
    @fi.pour
  end

  def teardown
    Homebrew::Hooks::Bottles.reset_hooks
  end
end

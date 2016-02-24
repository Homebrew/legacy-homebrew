require "testing_env"
require "formula"
require "compat/formula_specialties"
require "formula_installer"
require "keg"
require "tab"
require "testball"
require "testball_bottle"

class InstallTests < Homebrew::TestCase
  def temporary_install(formula)
    refute_predicate formula, :installed?

    installer = FormulaInstaller.new(formula)

    shutup { installer.install }

    keg = Keg.new(formula.prefix)

    assert_predicate formula, :installed?

    begin
      Tab.clear_cache
      refute_predicate Tab.for_keg(keg), :poured_from_bottle

      yield formula
    ensure
      Tab.clear_cache
      keg.unlink
      keg.uninstall
      formula.clear_cache
      # there will be log files when sandbox is enable.
      formula.logs.rmtree if formula.logs.directory?
    end

    refute_predicate keg, :exist?
    refute_predicate formula, :installed?
  end

  def test_a_basic_install
    temporary_install(Testball.new) do |f|
      # Test that things made it into the Keg
      assert_predicate f.prefix+"readme", :exist?

      assert_predicate f.bin, :directory?
      assert_equal 3, f.bin.children.length

      assert_predicate f.libexec, :directory?
      assert_equal 1, f.libexec.children.length

      refute_predicate f.prefix+"main.c", :exist?

      refute_predicate f.prefix+"license", :exist?

      # Test that things make it into the Cellar
      keg = Keg.new f.prefix
      keg.link

      bin = HOMEBREW_PREFIX+"bin"
      assert_predicate bin, :directory?
      assert_equal 3, bin.children.length
    end
  end

  def test_bottle_unneeded_formula_install
    MacOS.stubs(:has_apple_developer_tools?).returns(false)

    formula = Testball.new
    formula.stubs(:bottle_unneeded?).returns(true)
    formula.stubs(:bottle_disabled?).returns(true)

    refute_predicate formula, :bottled?
    assert_predicate formula, :bottle_unneeded?
    assert_predicate formula, :bottle_disabled?

    temporary_install(formula) do |f|
      assert_predicate f, :installed?
    end
  end

  def test_not_poured_from_bottle_when_compiler_specified
    assert_nil ARGV.cc

    cc_arg = "--cc=llvm-gcc"
    ARGV << cc_arg
    begin
      temporary_install(TestballBottle.new) do |f|
        tab = Tab.for_formula(f)
        assert_equal "llvm", tab.compiler
      end
    ensure
      ARGV.delete_if { |x| x == cc_arg }
    end
  end
end

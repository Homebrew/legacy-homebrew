require "testing_env"
require "formula"
require "compat/formula_specialties"
require "formula_installer"
require "keg"
require "testball_bottle"
require "testball"

class InstallBottleTests < Homebrew::TestCase
  def temporary_bottle_install(formula)
    refute_predicate formula, :installed?
    assert_predicate formula, :bottled?
    assert_predicate formula, :pour_bottle?

    installer = FormulaInstaller.new(formula)

    shutup { installer.install }

    keg = Keg.new(formula.prefix)

    assert_predicate formula, :installed?

    begin
      yield formula
    ensure
      keg.unlink
      keg.uninstall
      formula.clear_cache
      Dir["#{HOMEBREW_CACHE}/testball_bottle*"].each { |f| File.delete(f) }
      # there will be log files when sandbox is enable.
      formula.logs.rmtree if formula.logs.directory?
    end

    refute_predicate keg, :exist?
    refute_predicate formula, :installed?
  end

  def test_a_basic_bottle_install
    MacOS.stubs(:has_apple_developer_tools?).returns(false)

    temporary_bottle_install(TestballBottle.new) do |f|
      # Copied directly from test_formula_installer.rb as we expect
      # the same behavior

      # Test that things made it into the Keg
      assert_predicate f.bin, :directory?

      assert_predicate f.libexec, :directory?

      refute_predicate f.prefix+"main.c", :exist?

      # Test that things make it into the Cellar
      keg = Keg.new f.prefix
      keg.link

      bin = HOMEBREW_PREFIX+"bin"
      assert_predicate bin, :directory?
    end
  end

  def test_build_tools_error
    MacOS.stubs(:has_apple_developer_tools?).returns(false)

    # Testball doesn't have a bottle block, so use it to test this behavior
    formula = Testball.new

    refute_predicate formula, :installed?
    refute_predicate formula, :bottled?

    installer = FormulaInstaller.new(formula)

    assert_raises(BuildToolsError) do
      installer.install
    end

    refute_predicate formula, :installed?
  end
end

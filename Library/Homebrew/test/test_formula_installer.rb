require "testing_env"
require "formula"
require "compat/formula_specialties"
require "formula_installer"
require "keg"
require "testball"

class InstallTests < Homebrew::TestCase
  def temporary_install(formula)
    refute_predicate formula, :installed?

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
    end

    refute_predicate keg, :exist?
    refute_predicate formula, :installed?
  end

  def test_a_basic_install
    temporary_install(Testball.new) do |f|
      # Test that things made it into the Keg
      assert_predicate f.bin, :directory?
      assert_equal 3, f.bin.children.length

      assert_predicate f.libexec, :directory?
      assert_equal 1, f.libexec.children.length

      refute_predicate f.prefix+'main.c', :exist?

      # Test that things make it into the Cellar
      keg = Keg.new f.prefix
      keg.link

      bin = HOMEBREW_PREFIX+"bin"
      assert_predicate bin, :directory?
      assert_equal 3, bin.children.length
    end
  end

  def test_script_install
    mktmpdir do |dir|
      name = "test_script_formula"
      path = Pathname.new(dir)+"#{name}.rb"

      path.write <<-EOS.undent
        class #{Formulary.class_s(name)} < ScriptFileFormula
          url "file://#{File.expand_path(__FILE__)}"
          version "1"
        end
        EOS

      f = Formulary.factory(path.to_s)

      temporary_install(f) { assert_equal 1, f.bin.children.length }
    end
  end
end

require 'testing_env'
require 'formula'
require 'test/testball'
require 'keg'


class InstallTests < Homebrew::TestCase
  def temporary_install f
    f.prefix.mkpath
    keg = Keg.new(f.prefix)

    shutup do
      f.brew { f.install }
    end

    begin
      yield
    ensure
      keg.unlink
      keg.uninstall
      f.clear_cache
    end

    refute_predicate keg, :exist?
    refute_predicate f, :installed?
  end

  def test_a_basic_install
    f = TestBall.new

    refute_predicate f, :installed?

    temporary_install f do
      # Test that things made it into the Keg
      assert_predicate f.bin, :directory?
      assert_equal 3, f.bin.children.length

      libexec = f.prefix+'libexec'
      assert_predicate libexec, :directory?
      assert_equal 1, libexec.children.length

      refute_predicate f.prefix+'main.c', :exist?
      assert_predicate f, :installed?

      # Test that things make it into the Cellar
      keg = Keg.new f.prefix
      keg.link
      assert_equal 3, HOMEBREW_PREFIX.children.length
      assert_predicate HOMEBREW_PREFIX+'bin', :directory?
      assert_equal 3, (HOMEBREW_PREFIX+'bin').children.length
    end
  end

  def test_script_install
    f = Class.new(ScriptFileFormula) do
      url "file://#{File.expand_path(__FILE__)}"
      version "1"
      def initialize
        super "test_script_formula", Pathname.new(__FILE__).expand_path, :stable
      end
    end.new

    temporary_install(f) { assert_equal 1, f.bin.children.length }
  end
end

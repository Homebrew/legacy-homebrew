require 'testing_env'
require 'formula'
require 'test/testball'
require 'keg'


class InstallTests < Homebrew::TestCase
  def teardown
    HOMEBREW_CACHE.rmtree
  end

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
    end

    assert !keg.exist?
    assert !f.installed?
  end

  def test_a_basic_install
    f=TestBall.new

    assert !f.installed?

    temporary_install f do

      # Test that things made it into the Keg
      assert f.bin.directory?
      assert_equal 3, f.bin.children.length
      libexec=f.prefix+'libexec'
      assert libexec.directory?
      assert_equal 1, libexec.children.length
      assert !(f.prefix+'main.c').exist?
      assert f.installed?

      # Test that things make it into the Cellar
      keg=Keg.new f.prefix
      keg.link
      assert_equal 3, HOMEBREW_PREFIX.children.length
      assert((HOMEBREW_PREFIX+'bin').directory?)
      assert_equal 3, (HOMEBREW_PREFIX+'bin').children.length
    end
  end

  def test_script_install
    f = Class.new(ScriptFileFormula) do
      url "file://#{File.expand_path(__FILE__)}"
      version "1"
      def initialize
        super "test_script_formula", Pathname.new(__FILE__).expand_path
      end
    end.new

    temporary_install(f) { assert_equal 1, f.bin.children.length }
  end
end

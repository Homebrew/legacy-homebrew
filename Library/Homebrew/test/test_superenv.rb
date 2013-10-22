require 'testing_env'
require 'extend/ENV/super'

class SuperenvTests < Test::Unit::TestCase
  attr_reader :env, :bin

  def setup
    @env = {}.extend(Superenv)
    @bin = HOMEBREW_REPOSITORY/"Library/ENV/#{MacOS::Xcode.version}"
    bin.mkpath
  end

  def test_bin
    assert_equal bin, Superenv.bin
  end

  def test_initializes_deps
    assert_equal [], env.deps
    assert_equal [], env.keg_only_deps
  end

  def teardown
    bin.rmtree
  end
end

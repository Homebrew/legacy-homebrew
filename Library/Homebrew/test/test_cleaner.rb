require 'testing_env'
require 'cleaner'
require 'formula'

class CleanerTests < Test::Unit::TestCase
  include FileUtils

  def setup
    @f = formula("cleaner_test") { url 'foo-1.0' }
    @f.prefix.mkpath
  end

  def teardown
    @f.prefix.rmtree
  end

  def test_clean_file
    @f.bin.mkpath
    @f.lib.mkpath
    cp "#{TEST_FOLDER}/mach/a.out", @f.bin
    cp Dir["#{TEST_FOLDER}/mach/*.dylib"], @f.lib

    Cleaner.new @f

    assert_equal 0100555, (@f.bin/'a.out').stat.mode
    assert_equal 0100444, (@f.lib/'fat.dylib').stat.mode
    assert_equal 0100444, (@f.lib/'x86_64.dylib').stat.mode
    assert_equal 0100444, (@f.lib/'i386.dylib').stat.mode
  end
end

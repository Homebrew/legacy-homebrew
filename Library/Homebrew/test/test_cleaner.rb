require 'testing_env'
require 'cleaner'
require 'formula'

class CleanerTestBall < Formula
  url "file:///#{TEST_FOLDER}/tarballs/testball-0.1.tbz"

  def install
    TEST_FOLDER.cd do
      bin.mkpath
      lib.mkpath
      cp 'mach/a.out', bin
      cp 'mach/fat.dylib', lib
      cp 'mach/x86_64.dylib', lib
      cp 'mach/i386.dylib', lib
    end
  end
end

class CleanerTests < Test::Unit::TestCase
  def test_clean_file
    f = CleanerTestBall.new
    nostdout { f.brew { f.install } }

    assert_nothing_raised { Cleaner.new f }
    assert_equal 0100555, (f.bin/'a.out').stat.mode
    assert_equal 0100444, (f.lib/'fat.dylib').stat.mode
    assert_equal 0100444, (f.lib/'x86_64.dylib').stat.mode
    assert_equal 0100444, (f.lib/'i386.dylib').stat.mode
  end
end

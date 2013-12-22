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
    @f.prefix.rmtree if @f.prefix.exist?
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

  def test_prunes_prefix_if_empty
    Cleaner.new @f
    assert !@f.prefix.directory?
  end

  def test_prunes_empty_directories
    subdir = @f.bin/'subdir'
    subdir.mkpath

    Cleaner.new @f

    assert !@f.bin.directory?
    assert !subdir.directory?
  end

  def test_skip_clean_empty_directory
    @f.class.skip_clean 'bin'
    @f.bin.mkpath

    Cleaner.new @f

    assert @f.bin.directory?
  end

  def test_skip_clean_directory_with_empty_subdir
    @f.class.skip_clean 'bin'
    subdir = @f.bin/'subdir'
    subdir.mkpath

    Cleaner.new @f

    assert @f.bin.directory?
    assert subdir.directory?
  end

  def test_removes_symlink_when_target_was_pruned_first
    dir = @f.prefix/'b'
    symlink = @f.prefix/'a'

    dir.mkpath
    ln_s dir.basename, symlink

    Cleaner.new @f

    assert !dir.exist?
    assert !symlink.symlink?
    assert !symlink.exist?
  end

  def test_removes_symlink_pointing_to_empty_directory
    dir = @f.prefix/'b'
    symlink = @f.prefix/'c'

    dir.mkpath
    ln_s dir.basename, symlink

    Cleaner.new @f

    assert !dir.exist?
    assert !symlink.symlink?
    assert !symlink.exist?
  end

  def test_removes_broken_symlinks
    symlink = @f.prefix/'symlink'
    ln_s 'target', symlink

    Cleaner.new @f

    assert !symlink.symlink?
  end

  def test_skip_clean_broken_symlink
    @f.class.skip_clean 'symlink'
    symlink = @f.prefix/'symlink'
    ln_s 'target', symlink

    Cleaner.new @f

    assert symlink.symlink?
  end

  def test_skip_clean_symlink_pointing_to_empty_directory
    @f.class.skip_clean 'c'
    dir = @f.prefix/'b'
    symlink = @f.prefix/'c'

    dir.mkpath
    ln_s dir.basename, symlink

    Cleaner.new @f

    assert !dir.exist?
    assert symlink.symlink?
    assert !symlink.exist?
  end

  def test_skip_clean_symlink_when_target_pruned
    @f.class.skip_clean 'a'
    dir = @f.prefix/'b'
    symlink = @f.prefix/'a'

    dir.mkpath
    ln_s dir.basename, symlink

    Cleaner.new @f

    assert !dir.exist?
    assert symlink.symlink?
    assert !symlink.exist?
  end
end

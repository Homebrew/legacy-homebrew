require "testing_env"
require "cleaner"
require "formula"

class CleanerTests < Homebrew::TestCase
  include FileUtils

  def setup
    @f = formula("cleaner_test") { url "foo-1.0" }
    @f.prefix.mkpath
  end

  def teardown
    @f.rack.rmtree if @f.rack.exist?
  end

  def test_clean_file
    @f.bin.mkpath
    @f.lib.mkpath
    cp "#{TEST_DIRECTORY}/mach/a.out", @f.bin
    cp Dir["#{TEST_DIRECTORY}/mach/*.dylib"], @f.lib

    Cleaner.new(@f).clean

    assert_equal 0100555, (@f.bin/"a.out").stat.mode
    assert_equal 0100444, (@f.lib/"fat.dylib").stat.mode
    assert_equal 0100444, (@f.lib/"x86_64.dylib").stat.mode
    assert_equal 0100444, (@f.lib/"i386.dylib").stat.mode
  end

  def test_prunes_prefix_if_empty
    Cleaner.new(@f).clean
    refute_predicate @f.prefix, :directory?
  end

  def test_prunes_empty_directories
    subdir = @f.bin/"subdir"
    subdir.mkpath

    Cleaner.new(@f).clean

    refute_predicate @f.bin, :directory?
    refute_predicate subdir, :directory?
  end

  def test_skip_clean_empty_directory
    @f.class.skip_clean "bin"
    @f.bin.mkpath

    Cleaner.new(@f).clean

    assert_predicate @f.bin, :directory?
  end

  def test_skip_clean_directory_with_empty_subdir
    @f.class.skip_clean "bin"
    subdir = @f.bin/"subdir"
    subdir.mkpath

    Cleaner.new(@f).clean

    assert_predicate @f.bin, :directory?
    assert_predicate subdir, :directory?
  end

  def test_removes_symlink_when_target_was_pruned_first
    dir = @f.prefix/"b"
    symlink = @f.prefix/"a"

    dir.mkpath
    ln_s dir.basename, symlink

    Cleaner.new(@f).clean

    refute_predicate dir, :exist?
    refute_predicate symlink, :symlink?
    refute_predicate symlink, :exist?
  end

  def test_removes_symlink_pointing_to_empty_directory
    dir = @f.prefix/"b"
    symlink = @f.prefix/"c"

    dir.mkpath
    ln_s dir.basename, symlink

    Cleaner.new(@f).clean

    refute_predicate dir, :exist?
    refute_predicate symlink, :symlink?
    refute_predicate symlink, :exist?
  end

  def test_removes_broken_symlinks
    symlink = @f.prefix/"symlink"
    ln_s "target", symlink

    Cleaner.new(@f).clean

    refute_predicate symlink, :symlink?
  end

  def test_skip_clean_broken_symlink
    @f.class.skip_clean "symlink"
    symlink = @f.prefix/"symlink"
    ln_s "target", symlink

    Cleaner.new(@f).clean

    assert_predicate symlink, :symlink?
  end

  def test_skip_clean_symlink_pointing_to_empty_directory
    @f.class.skip_clean "c"
    dir = @f.prefix/"b"
    symlink = @f.prefix/"c"

    dir.mkpath
    ln_s dir.basename, symlink

    Cleaner.new(@f).clean

    refute_predicate dir, :exist?
    assert_predicate symlink, :symlink?
    refute_predicate symlink, :exist?
  end

  def test_skip_clean_symlink_when_target_pruned
    @f.class.skip_clean "a"
    dir = @f.prefix/"b"
    symlink = @f.prefix/"a"

    dir.mkpath
    ln_s dir.basename, symlink

    Cleaner.new(@f).clean

    refute_predicate dir, :exist?
    assert_predicate symlink, :symlink?
    refute_predicate symlink, :exist?
  end

  def test_removes_la_files
    file = @f.lib/"foo.la"

    @f.lib.mkpath
    touch file

    Cleaner.new(@f).clean

    refute_predicate file, :exist?
  end

  def test_skip_clean_la
    file = @f.lib/"foo.la"

    @f.class.skip_clean :la
    @f.lib.mkpath
    touch file

    Cleaner.new(@f).clean

    assert_predicate file, :exist?
  end

  def test_remove_charset_alias
    file = @f.lib/"charset.alias"

    @f.lib.mkpath
    touch file

    Cleaner.new(@f).clean

    refute_predicate file, :exist?
  end

  def test_skip_clean_subdir
    dir = @f.lib/"subdir"
    @f.class.skip_clean "lib/subdir"

    dir.mkpath

    Cleaner.new(@f).clean

    assert_predicate dir, :directory?
  end

  def test_skip_clean_paths_are_anchored_to_prefix
    dir1 = @f.bin/"a"
    dir2 = @f.lib/"bin/a"

    @f.class.skip_clean "bin/a"
    dir1.mkpath
    dir2.mkpath

    Cleaner.new(@f).clean

    assert_predicate dir1, :exist?
    refute_predicate dir2, :exist?
  end
end

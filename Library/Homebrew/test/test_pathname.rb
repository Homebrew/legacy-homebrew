require "testing_env"
require "tmpdir"
require "extend/pathname"
require "install_renamed"

module PathnameTestExtension
  include FileUtils

  def setup
    @src  = Pathname.new(mktmpdir)
    @dst  = Pathname.new(mktmpdir)
    @file = @src+"foo"
    @dir  = @src+"bar"
  end

  def teardown
    rmtree(@src)
    rmtree(@dst)
  end
end

class PathnameTests < Homebrew::TestCase
  include PathnameTestExtension

  def test_rmdir_if_possible
    mkdir_p @dir
    touch @dir+"foo"

    assert !@dir.rmdir_if_possible
    assert_predicate @dir, :directory?

    rm_f @dir+"foo"
    assert @dir.rmdir_if_possible
    refute_predicate @dir, :exist?
  end

  def test_rmdir_if_possible_ignore_DS_Store
    mkdir_p @dir
    touch @dir+".DS_Store"
    assert @dir.rmdir_if_possible
    refute_predicate @dir, :exist?
  end

  def test_write
    @file.write("CONTENT")
    assert_equal "CONTENT", File.read(@file)
  end

  def test_write_does_not_overwrite
    touch @file
    assert_raises(RuntimeError) { @file.write("CONTENT") }
  end

  def test_append_lines
    touch @file
    @file.append_lines("CONTENT")
    assert_equal "CONTENT\n", File.read(@file)
    @file.append_lines("CONTENTS")
    assert_equal "CONTENT\nCONTENTS\n", File.read(@file)
  end

  def test_append_lines_does_not_create
    assert_raises(RuntimeError) { @file.append_lines("CONTENT") }
  end

  def test_atomic_write
    touch @file
    @file.atomic_write("CONTENT")
    assert_equal "CONTENT", File.read(@file)
  end

  def test_atomic_write_preserves_permissions
    File.open(@file, "w", 0100777) {}
    @file.atomic_write("CONTENT")
    assert_equal 0100777 & ~File.umask, @file.stat.mode
  end

  def test_atomic_write_preserves_default_permissions
    @file.atomic_write("CONTENT")
    sentinel = @file.parent.join("sentinel")
    touch sentinel
    assert_equal sentinel.stat.mode, @file.stat.mode
  end

  def test_ensure_writable
    touch @file
    chmod 0555, @file
    @file.ensure_writable { assert_predicate @file, :writable? }
    refute_predicate @file, :writable?
  end

  def test_extname
    assert_equal ".tar.gz", Pathname("foo-0.1.tar.gz").extname
    assert_equal ".cpio.gz", Pathname("foo-0.1.cpio.gz").extname
  end

  def test_stem
    assert_equal "foo-0.1", Pathname("foo-0.1.tar.gz").stem
    assert_equal "foo-0.1", Pathname("foo-0.1.cpio.gz").stem
  end

  def test_install_missing_file
    assert_raises(Errno::ENOENT) { @dst.install "non_existent_file" }
  end

  def test_install_removes_original
    touch @file
    @dst.install(@file)

    assert_predicate @dst/@file.basename, :exist?
    refute_predicate @file, :exist?
  end

  def test_install_creates_intermediate_directories
    touch @file
    refute_predicate @dir, :directory?
    @dir.install(@file)
    assert_predicate @dir, :directory?
  end

  def test_install_renamed
    @dst.extend(InstallRenamed)

    @file.write "a"
    @dst.install @file
    @file.write "b"
    @dst.install @file

    assert_equal "a", File.read(@dst+@file.basename)
    assert_equal "b", File.read(@dst+"#{@file.basename}.default")
  end

  def test_install_renamed_directory
    @dst.extend(InstallRenamed)
    @file.write "a"
    @dst.install @src
    assert_equal "a", File.read(@dst+@src.basename+@file.basename)
  end

  def test_cp_path_sub_file
    @file.write "a"
    @file.cp_path_sub @src, @dst
    assert_equal "a", File.read(@dst+"foo")
  end

  def test_cp_path_sub_directory
    @dir.mkpath
    @dir.cp_path_sub @src, @dst
    assert_predicate @dst+@dir.basename, :directory?
  end
end

class PathnameInstallTests < Homebrew::TestCase
  include PathnameTestExtension

  def setup
    super
    (@src+"a.txt").write "This is sample file a."
    (@src+"b.txt").write "This is sample file b."
  end

  def test_install
    @dst.install @src+"a.txt"

    assert_predicate @dst+"a.txt", :exist?, "a.txt was not installed"
    refute_predicate @dst+"b.txt", :exist?, "b.txt was installed."
  end

  def test_install_list
    @dst.install [@src+"a.txt", @src+"b.txt"]

    assert_predicate @dst+"a.txt", :exist?, "a.txt was not installed"
    assert_predicate @dst+"b.txt", :exist?, "b.txt was not installed"
  end

  def test_install_glob
    @dst.install Dir[@src+"*.txt"]

    assert_predicate @dst+"a.txt", :exist?, "a.txt was not installed"
    assert_predicate @dst+"b.txt", :exist?, "b.txt was not installed"
  end

  def test_install_directory
    bin = @src+"bin"
    bin.mkpath
    mv Dir[@src+"*.txt"], bin
    @dst.install bin

    assert_predicate @dst+"bin/a.txt", :exist?, "a.txt was not installed"
    assert_predicate @dst+"bin/b.txt", :exist?, "b.txt was not installed"
  end

  def test_install_rename
    @dst.install @src+"a.txt" => "c.txt"

    assert_predicate @dst+"c.txt", :exist?, "c.txt was not installed"
    refute_predicate @dst+"a.txt", :exist?, "a.txt was installed but not renamed"
    refute_predicate @dst+"b.txt", :exist?, "b.txt was installed"
  end

  def test_install_rename_more
    @dst.install(@src+"a.txt" => "c.txt", @src+"b.txt" => "d.txt")

    assert_predicate @dst+"c.txt", :exist?, "c.txt was not installed"
    assert_predicate @dst+"d.txt", :exist?, "d.txt was not installed"
    refute_predicate @dst+"a.txt", :exist?, "a.txt was installed but not renamed"
    refute_predicate @dst+"b.txt", :exist?, "b.txt was installed but not renamed"
  end

  def test_install_rename_directory
    bin = @src+"bin"
    bin.mkpath
    mv Dir[@src+"*.txt"], bin
    @dst.install bin => "libexec"

    refute_predicate @dst+"bin", :exist?, "bin was installed but not renamed"
    assert_predicate @dst+"libexec/a.txt", :exist?, "a.txt was not installed"
    assert_predicate @dst+"libexec/b.txt", :exist?, "b.txt was not installed"
  end

  def test_install_symlink
    bin = @src+"bin"
    bin.mkpath
    mv Dir[@src+"*.txt"], bin
    @dst.install_symlink bin

    assert_predicate @dst+"bin", :symlink?
    assert_predicate @dst+"bin", :directory?
    assert_predicate @dst+"bin/a.txt", :exist?
    assert_predicate @dst+"bin/b.txt", :exist?
    assert_predicate((@dst+"bin").readlink, :relative?)
  end

  def test_install_relative_symlink
    @dst.install_symlink "foo" => "bar"
    assert_equal Pathname.new("foo"), (@dst+"bar").readlink
  end
end

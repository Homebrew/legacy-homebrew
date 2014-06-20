require 'testing_env'
require 'tmpdir'
require 'extend/pathname'

class PathnameExtensionTests < Homebrew::TestCase
  include FileUtils

  def setup
    @src  = Pathname.new(Dir.mktmpdir)
    @dst  = Pathname.new(Dir.mktmpdir)
    @file = @src+'foo'
    @dir  = @src+'bar'
  end

  def teardown
    rmtree(@src)
    rmtree(@dst)
  end

  def test_rmdir_if_possible
    mkdir_p @dir
    touch @dir+'foo'

    assert !@dir.rmdir_if_possible
    assert_predicate @dir, :directory?

    rm_f @dir+'foo'
    assert @dir.rmdir_if_possible
    refute_predicate @dir, :exist?
  end

  def test_rmdir_if_possible_ignore_DS_Store
    mkdir_p @dir
    touch @dir+'.DS_Store'
    assert @dir.rmdir_if_possible
    refute_predicate @dir, :exist?
  end

  def test_write
    @file.write('CONTENT')
    assert_equal 'CONTENT', File.read(@file)
  end

  def test_write_does_not_overwrite
    touch @file
    assert_raises(RuntimeError) { @file.write('CONTENT') }
  end

  def test_atomic_write
    touch @file
    @file.atomic_write('CONTENT')
    assert_equal 'CONTENT', File.read(@file)
  end

  def test_atomic_write_preserves_permissions
    File.open(@file, "w", 0100777) { }
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
    assert_equal '.tar.gz', Pathname('foo-0.1.tar.gz').extname
    assert_equal '.cpio.gz', Pathname('foo-0.1.cpio.gz').extname
  end

  def test_stem
    assert_equal 'foo-0.1', Pathname('foo-0.1.tar.gz').stem
    assert_equal 'foo-0.1', Pathname('foo-0.1.cpio.gz').stem
  end

  def test_install_missing_file
    assert_raises(RuntimeError) do
      @dst.install 'non_existent_file'
    end
  end

  def test_install_removes_original
    touch @file
    @dst.install(@file)

    assert_predicate @dst/@file.basename, :exist?
    refute_predicate @file, :exist?
  end

  def setup_install_test
    cd @src do
      (@src+'a.txt').write 'This is sample file a.'
      (@src+'b.txt').write 'This is sample file b.'
      yield
    end
  end

  def test_install
    setup_install_test do
      @dst.install 'a.txt'

      assert_predicate @dst+"a.txt", :exist?, "a.txt was not installed"
      refute_predicate @dst+"b.txt", :exist?, "b.txt was installed."
    end
  end

  def test_install_list
    setup_install_test do
      @dst.install %w[a.txt b.txt]

      assert_predicate @dst+"a.txt", :exist?, "a.txt was not installed"
      assert_predicate @dst+"b.txt", :exist?, "b.txt was not installed"
    end
  end

  def test_install_glob
    setup_install_test do
      @dst.install Dir['*.txt']

      assert_predicate @dst+"a.txt", :exist?, "a.txt was not installed"
      assert_predicate @dst+"b.txt", :exist?, "b.txt was not installed"
    end
  end

  def test_install_directory
    setup_install_test do
      mkdir_p 'bin'
      mv Dir['*.txt'], 'bin'

      @dst.install 'bin'

      assert_predicate @dst+"bin/a.txt", :exist?, "a.txt was not installed"
      assert_predicate @dst+"bin/b.txt", :exist?, "b.txt was not installed"
    end
  end

  def test_install_rename
    setup_install_test do
      @dst.install 'a.txt' => 'c.txt'

      assert_predicate @dst+"c.txt", :exist?, "c.txt was not installed"
      refute_predicate @dst+"a.txt", :exist?, "a.txt was installed but not renamed"
      refute_predicate @dst+"b.txt", :exist?, "b.txt was installed"
    end
  end

  def test_install_rename_more
    setup_install_test do
      @dst.install({'a.txt' => 'c.txt', 'b.txt' => 'd.txt'})

      assert_predicate @dst+"c.txt", :exist?, "c.txt was not installed"
      assert_predicate @dst+"d.txt", :exist?, "d.txt was not installed"
      refute_predicate @dst+"a.txt", :exist?, "a.txt was installed but not renamed"
      refute_predicate @dst+"b.txt", :exist?, "b.txt was installed but not renamed"
    end
  end

  def test_install_rename_directory
    setup_install_test do
      mkdir_p 'bin'
      mv Dir['*.txt'], 'bin'

      @dst.install 'bin' => 'libexec'

      refute_predicate @dst+"bin", :exist?, "bin was installed but not renamed"
      assert_predicate @dst+"libexec/a.txt", :exist?, "a.txt was not installed"
      assert_predicate @dst+"libexec/b.txt", :exist?, "b.txt was not installed"
    end
  end

  def test_install_symlink
    setup_install_test do
      mkdir_p 'bin'
      mv Dir['*.txt'], 'bin'

      @dst.install_symlink @src+'bin'

      assert_predicate @dst+"bin", :symlink?
      assert_predicate @dst+"bin", :directory?
      assert_predicate @dst+"bin/a.txt", :exist?
      assert_predicate @dst+"bin/b.txt", :exist?

      assert_predicate (@dst+"bin").readlink, :relative?
    end
  end

  def test_install_creates_intermediate_directories
    touch @file
    refute_predicate @dir, :directory?
    @dir.install(@file)
    assert_predicate @dir, :directory?
  end
end

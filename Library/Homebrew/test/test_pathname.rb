require 'testing_env'
require 'tmpdir'
require 'extend/pathname'

class PathnameExtensionTests < Test::Unit::TestCase
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
    assert @dir.directory?

    rm_f @dir+'foo'
    assert @dir.rmdir_if_possible
    assert !@dir.exist?
  end

  def test_rmdir_if_possible_ignore_DS_Store
    mkdir_p @dir
    touch @dir+'.DS_Store'
    assert @dir.rmdir_if_possible
    assert !@dir.exist?
  end

  def test_write
    @file.write('CONTENT')
    assert_equal 'CONTENT', File.read(@file)
  end

  def test_write_does_not_overwrite
    touch @file
    assert_raises(RuntimeError) { @file.write('CONTENT') }
  end

  def test_chmod_R
    perms = 0777
    FileUtils.expects(:chmod_R).with(perms, @dir.to_s)
    @dir.chmod_R(perms)
  end

  def test_atomic_write
    touch @file
    @file.atomic_write('CONTENT')
    assert_equal 'CONTENT', File.read(@file)
  end

  def test_cp
    touch @file
    mkdir_p @dir

    @file.cp(@dir)
    assert @file.file?
    assert((@dir+@file.basename).file?)

    @dir.cp(@dst)
    assert @dir.directory?
    assert((@dst+@dir.basename).directory?)
  end

  def test_ensure_writable
    touch @file
    chmod 0555, @file
    @file.ensure_writable { assert @file.writable? }
    assert !@file.writable?
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
    orig_file = @file
    touch @file

    @file, _ = @dst.install(@file)

    assert_equal orig_file.basename, @file.basename
    assert @file.exist?
    assert !orig_file.exist?
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

      assert((@dst+'a.txt').exist?, 'a.txt not installed.')
      assert(!(@dst+'b.txt').exist?, 'b.txt was installed.')
    end
  end

  def test_install_list
    setup_install_test do
      @dst.install %w[a.txt b.txt]

      assert((@dst+'a.txt').exist?, 'a.txt not installed.')
      assert((@dst+'b.txt').exist?, 'b.txt not installed.')
    end
  end

  def test_install_glob
    setup_install_test do
      @dst.install Dir['*.txt']

      assert((@dst+'a.txt').exist?, 'a.txt not installed.')
      assert((@dst+'b.txt').exist?, 'b.txt not installed.')
    end
  end

  def test_install_directory
    setup_install_test do
      mkdir_p 'bin'
      mv Dir['*.txt'], 'bin'

      @dst.install 'bin'

      assert((@dst+'bin/a.txt').exist?, 'a.txt not installed.')
      assert((@dst+'bin/b.txt').exist?, 'b.txt not installed.')
    end
  end

  def test_install_rename
    setup_install_test do
      @dst.install 'a.txt' => 'c.txt'

      assert((@dst+'c.txt').exist?, 'c.txt not installed.')
      assert(!(@dst+'a.txt').exist?, 'a.txt was installed but not renamed.')
      assert(!(@dst+'b.txt').exist?, 'b.txt was installed.')
    end
  end

  def test_install_rename_more
    setup_install_test do
      @dst.install({'a.txt' => 'c.txt', 'b.txt' => 'd.txt'})

      assert((@dst+'c.txt').exist?, 'c.txt not installed.')
      assert((@dst+'d.txt').exist?, 'd.txt not installed.')
      assert(!(@dst+'a.txt').exist?, 'a.txt was installed but not renamed.')
      assert(!(@dst+'b.txt').exist?, 'b.txt was installed but not renamed.')
    end
  end

  def test_install_rename_directory
    setup_install_test do
      mkdir_p 'bin'
      mv Dir['*.txt'], 'bin'

      @dst.install 'bin' => 'libexec'

      assert(!(@dst+'bin').exist?, 'bin was installed but not renamed.')
      assert((@dst+'libexec/a.txt').exist?, 'a.txt not installed.')
      assert((@dst+'libexec/b.txt').exist?, 'b.txt not installed.')
    end
  end

  def test_install_symlink
    setup_install_test do
      mkdir_p 'bin'
      mv Dir['*.txt'], 'bin'

      @dst.install_symlink @src+'bin'

      assert((@dst+'bin').symlink?)
      assert((@dst+'bin').directory?)
      assert((@dst+'bin/a.txt').exist?)
      assert((@dst+'bin/b.txt').exist?)
    end
  end

  def test_install_returns_installed_paths
    foo, bar = @src+'foo', @src+'bar'
    touch [foo, bar]
    dirs = @dst.install(foo, bar)
    assert_equal [@dst+'foo', @dst+'bar'], dirs
  end

  def test_install_creates_intermediate_directories
    touch @file
    assert !@dir.directory?
    @dir.install(@file)
    assert @dir.directory?
  end
end

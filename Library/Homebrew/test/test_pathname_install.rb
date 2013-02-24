require 'testing_env'

TEMP_FOLDER = HOMEBREW_PREFIX+"temp_dir"
TARGET_FOLDER = TEMP_FOLDER+'folder1'

class PathnameInstallTests < Test::Unit::TestCase
  def setup
    FileUtils.mkdir_p TEMP_FOLDER
  end

  def with_temp_folder
    TEMP_FOLDER.cd do
      # Keep these around while building out tests, to make sure
      # that test folders start out clean.
      assert !TARGET_FOLDER.exist?, "setup failed."

      (TEMP_FOLDER+'a.txt').write "This is sample file a."
      (TEMP_FOLDER+'b.txt').write "This is sample file b."
      yield
    end
  end

  def test_install_missing_file
    assert_raises(RuntimeError) do
      Pathname.getwd.install 'non_existant_file'
    end
  end

  def test_install
    with_temp_folder do
      TARGET_FOLDER.install 'a.txt'

      assert  (TARGET_FOLDER+'a.txt').exist?, "a.txt not installed."
      assert !(TARGET_FOLDER+'b.txt').exist?, "b.txt was installed."
    end
  end

  def test_install_list
    with_temp_folder do
      TARGET_FOLDER.install %w[a.txt b.txt]

      assert (TARGET_FOLDER+'a.txt').exist?, "a.txt not installed."
      assert (TARGET_FOLDER+'b.txt').exist?, "b.txt not installed."
    end
  end

  def test_install_glob
    with_temp_folder do
      TARGET_FOLDER.install Dir['*.txt']

      assert (TARGET_FOLDER+'a.txt').exist?, "a.txt not installed."
      assert (TARGET_FOLDER+'b.txt').exist?, "b.txt not installed."
    end
  end

  def test_install_folder
    with_temp_folder do
      FileUtils.mkdir_p "bin"
      system "mv *.txt bin"

      TARGET_FOLDER.install "bin"

      assert (TARGET_FOLDER+'bin/a.txt').exist?, "a.txt not installed."
      assert (TARGET_FOLDER+'bin/b.txt').exist?, "b.txt not installed."
    end
  end

  def test_install_rename
    with_temp_folder do
      TARGET_FOLDER.install 'a.txt' => 'c.txt'

      assert  (TARGET_FOLDER+'c.txt').exist?, "c.txt not installed."
      assert !(TARGET_FOLDER+'a.txt').exist?, "a.txt was installed but not renamed."
      assert !(TARGET_FOLDER+'b.txt').exist?, "b.txt was installed."
    end
  end

  def test_install_rename_more
    with_temp_folder do
      TARGET_FOLDER.install({'a.txt' => 'c.txt', 'b.txt' => 'd.txt'})

      assert  (TARGET_FOLDER+'c.txt').exist?, "c.txt not installed."
      assert  (TARGET_FOLDER+'d.txt').exist?, "d.txt not installed."
      assert !(TARGET_FOLDER+'a.txt').exist?, "a.txt was installed but not renamed."
      assert !(TARGET_FOLDER+'b.txt').exist?, "b.txt was installed but not renamed."
    end
  end

  def test_install_rename_folder
    with_temp_folder do
      FileUtils.mkdir_p "bin"
      system "mv *.txt bin"

      TARGET_FOLDER.install "bin" => "libexec"

      assert !(TARGET_FOLDER+'bin').exist?, "bin was installed but not renamed."
      assert  (TARGET_FOLDER+'libexec/a.txt').exist?, "a.txt not installed."
      assert  (TARGET_FOLDER+'libexec/b.txt').exist?, "b.txt not installed."
    end
  end

  # test_install_symlink
  # test_install_relative_symlink

  def teardown
    FileUtils.rm_rf TEMP_FOLDER
  end
end

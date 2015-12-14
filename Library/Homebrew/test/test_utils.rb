require "testing_env"
require "tempfile"

class UtilTests < Homebrew::TestCase
  def setup
    @dir = Pathname.new(mktmpdir)
  end

  def teardown
    @dir.rmtree
  end

  def test_put_columns_empty
    # Issue #217 put columns with new results fails.
    assert_silent { puts_columns [] }
  end

  def test_which
    cmd = @dir/"foo"
    FileUtils.touch cmd
    cmd.chmod 0744
    assert_equal Pathname.new(cmd),
      which(File.basename(cmd), File.dirname(cmd))
  end

  def test_which_skip_non_executables
    cmd = @dir/"foo"
    FileUtils.touch cmd
    assert_nil which(File.basename(cmd), File.dirname(cmd))
  end

  def test_which_skip_malformed_path
    # 'which' should not fail if a path is malformed
    # see https://github.com/Homebrew/homebrew/issues/32789 for an example
    cmd = @dir/"foo"
    FileUtils.touch cmd
    cmd.chmod 0744

    # ~~ will fail because ~foo resolves to foo's home and there is no '~' user
    # here
    assert_equal Pathname.new(cmd),
      which(File.basename(cmd), "~~#{File::PATH_SEPARATOR}#{File.dirname(cmd)}")
  end

  def test_popen_read
    out = Utils.popen_read("/bin/sh", "-c", "echo success").chomp
    assert_equal "success", out
    assert_predicate $?, :success?
  end

  def test_pretty_duration
    assert_equal "2 seconds", pretty_duration(1)
    assert_equal "2 seconds", pretty_duration(2.5)
    assert_equal "42 seconds", pretty_duration(42)
    assert_equal "4.2 minutes", pretty_duration(252)
    assert_equal "4.2 minutes", pretty_duration(252.45)
  end

  def test_plural
    assert_equal "", plural(1)
    assert_equal "s", plural(0)
    assert_equal "s", plural(42)
    assert_equal "", plural(42, "")
  end
end

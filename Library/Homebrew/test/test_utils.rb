require "testing_env"
require "utils"
require "tempfile"

class TtyTests < Homebrew::TestCase
  def test_strip_ansi
    assert_equal "hello",
      Tty.strip_ansi("\033\[36;7mhello\033\[0m")
  end

  def test_truncate
    Tty.stubs(:width).returns 10
    assert_equal "foobar", Tty.truncate("foobar something very long")
    assert_equal "trunca", Tty.truncate("truncate")
  end

  def test_no_tty_formatting
    $stdout.stubs(:tty?).returns false
    assert_nil Tty.blue
    assert_nil Tty.white
    assert_nil Tty.red
    assert_nil Tty.green
    assert_nil Tty.gray
    assert_nil Tty.yellow
    assert_nil Tty.reset
    assert_nil Tty.em
    assert_nil Tty.highlight
  end
end

class UtilTests < Homebrew::TestCase
  def setup
    @dir = Pathname.new(mktmpdir)
    @env = ENV.to_hash
  end

  def teardown
    @dir.rmtree
    ENV.replace @env
  end

  def test_ofail
    shutup { ofail "foo" }
    assert Homebrew.failed
  ensure
    Homebrew.failed = false
  end

  def test_odie
    expects(:exit).returns 1
    shutup { odie "foo" }
  end

  def test_pretty_installed
    $stdout.stubs(:tty?).returns false
    assert_equal "foo", pretty_installed("foo")
  end

  def test_pretty_uninstalled
    $stdout.stubs(:tty?).returns false
    assert_equal "foo", pretty_uninstalled("foo")
  end

  def test_interactive_shell
    mktmpdir do |path|
      shell = "#{path}/myshell"
      File.open(shell, "w") do |file|
        file.write "#!/bin/sh\necho called > #{path}/called\n"
      end
      FileUtils.chmod 0755, shell
      ENV["SHELL"] = shell
      assert_nothing_raised { interactive_shell }
      assert File.exist? "#{path}/called"
    end
  end

  def test_run_as_not_developer
    ENV["HOMEBREW_DEVELOPER"] = "foo"
    run_as_not_developer do
      assert_nil ENV["HOMEBREW_DEVELOPER"]
    end
    assert_equal "foo", ENV["HOMEBREW_DEVELOPER"]
  end

  def test_put_columns_empty
    # Issue #217 put columns with no results fails.
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

  def test_which_all
    (@dir/"bar/baz").mkpath
    cmd1 = @dir/"foo"
    cmd2 = @dir/"bar/foo"
    cmd3 = @dir/"bar/baz/foo"
    FileUtils.touch cmd2
    [cmd1, cmd3].each do |cmd|
      FileUtils.touch cmd
      cmd.chmod 0744
    end
    assert_equal [cmd3, cmd1],
      which_all("foo", "#{@dir}/bar/baz:#{@dir}/baz:#{@dir}:~baduserpath")
  end

  def test_which_editor
    ENV["HOMEBREW_EDITOR"] = "vemate"
    assert_equal "vemate", which_editor
  end

  def test_gzip
    mktmpdir do |path|
      somefile = "#{path}/somefile"
      FileUtils.touch somefile
      assert_equal "#{somefile}.gz",
        gzip(somefile)[0].to_s
      assert File.exist?("#{somefile}.gz")
    end
  end

  def test_shell_profile
    ENV["SHELL"] = "/bin/sh"
    assert_equal "~/.bash_profile", shell_profile
    ENV["SHELL"] = "/bin/bash"
    assert_equal "~/.bash_profile", shell_profile
    ENV["SHELL"] = "/bin/another_shell"
    assert_equal "~/.bash_profile", shell_profile
    ENV["SHELL"] = "/bin/zsh"
    assert_equal "~/.zshrc", shell_profile
    ENV["SHELL"] = "/bin/ksh"
    assert_equal "~/.kshrc", shell_profile
  end

  def test_popen_read
    out = Utils.popen_read("/bin/sh", "-c", "echo success").chomp
    assert_equal "success", out
    assert_predicate $?, :success?
  end

  def test_popen_read_with_block
    out = Utils.popen_read("/bin/sh", "-c", "echo success") do |pipe|
      pipe.read.chomp
    end
    assert_equal "success", out
    assert_predicate $?, :success?
  end

  def test_popen_write_with_block
    Utils.popen_write("/usr/bin/grep", "-q", "success") do |pipe|
      pipe.write("success\n")
    end
    assert_predicate $?, :success?
  end

  def test_pretty_duration
    assert_equal "1 second", pretty_duration(1)
    assert_equal "2 seconds", pretty_duration(2.5)
    assert_equal "42 seconds", pretty_duration(42)
    assert_equal "4 minutes", pretty_duration(240)
    assert_equal "4 minutes 12 seconds", pretty_duration(252.45)
  end

  def test_plural
    assert_equal "", plural(1)
    assert_equal "s", plural(0)
    assert_equal "s", plural(42)
    assert_equal "", plural(42, "")
  end

  def test_disk_usage_readable
    assert_equal "1B", disk_usage_readable(1)
    assert_equal "1000B", disk_usage_readable(1000)
    assert_equal "1K", disk_usage_readable(1024)
    assert_equal "1K", disk_usage_readable(1025)
    assert_equal "4.2M", disk_usage_readable(4_404_020)
    assert_equal "4.2G", disk_usage_readable(4_509_715_660)
  end

  def test_number_readable
    assert_equal "1", number_readable(1)
    assert_equal "1,000", number_readable(1_000)
    assert_equal "1,000,000", number_readable(1_000_000)
  end

  def test_user_agent
    ENV.delete "CI"
    ENV.delete "JENKINS_URL"
    refute_includes homebrew_user_agent, "CI"
    ENV["CI"] = "true"
    assert_includes homebrew_user_agent, "CI"
    assert_includes homebrew_user_agent, HOMEBREW_VERSION
  end
end

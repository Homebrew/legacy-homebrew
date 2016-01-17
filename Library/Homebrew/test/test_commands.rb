require "testing_env"
require "cmd/commands"
require "fileutils"

class CommandsCommandTests < Homebrew::TestCase
  def setup
    @cmds = [
      # internal commands
      HOMEBREW_LIBRARY_PATH/"cmd/rbcmd.rb",
      HOMEBREW_LIBRARY_PATH/"cmd/shcmd.sh",

      # internal development commands
      HOMEBREW_LIBRARY_PATH/"dev-cmd/rbdevcmd.rb",
      HOMEBREW_LIBRARY_PATH/"dev-cmd/shdevcmd.sh",
    ]

    @cmds.each { |f| FileUtils.touch f }
  end

  def teardown
    @cmds.each { |f| f.unlink }
  end

  def test_internal_commands
    cmds = Homebrew.internal_commands
    assert cmds.include?("rbcmd"), "Ruby commands files should be recognized"
    assert cmds.include?("shcmd"), "Shell commands files should be recognized"
    refute cmds.include?("rbdevcmd"), "Dev commands shouldn't be included"
  end

  def test_internal_development_commands
    cmds = Homebrew.internal_development_commands
    assert cmds.include?("rbdevcmd"), "Ruby commands files should be recognized"
    assert cmds.include?("shdevcmd"), "Shell commands files should be recognized"
    refute cmds.include?("rbcmd"), "Non-dev commands shouldn't be included"
  end

  def test_external_commands
    env = ENV.to_hash

    mktmpdir do |dir|
      %w[brew-t1 brew-t2.rb brew-t3.py].each do |file|
        path = "#{dir}/#{file}"
        FileUtils.touch path
        FileUtils.chmod 0744, path
      end

      FileUtils.touch "#{dir}/t4"

      ENV["PATH"] = "#{ENV["PATH"]}#{File::PATH_SEPARATOR}#{dir}"
      cmds = Homebrew.external_commands

      assert cmds.include?("t1"), "Executable files should be included"
      assert cmds.include?("t2"), "Executable Ruby files should be included"
      refute cmds.include?("t3"),
        "Executable files with a non Ruby extension shoudn't be included"
      refute cmds.include?("t4"), "Non-executable files shouldn't be included"
    end
  ensure
    ENV.replace(env)
  end
end

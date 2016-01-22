require "testing_env"

class BashTests < Homebrew::TestCase
  def assert_valid_bash_syntax(files)
    output = Utils.popen_read("/bin/bash -n #{files} 2>&1")
    assert $?.success?, output
  end

  def test_bin_brew
    assert_valid_bash_syntax "#{HOMEBREW_LIBRARY_PATH.parent.parent}/bin/brew"
  end

  def test_bash_cmds
    assert_valid_bash_syntax "#{HOMEBREW_LIBRARY_PATH}/cmd/*.sh"
  end
end

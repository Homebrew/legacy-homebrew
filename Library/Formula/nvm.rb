class Nvm < Formula
  desc "Manage multiple Node.js versions"
  homepage "https://github.com/creationix/nvm"
  url "https://github.com/creationix/nvm/archive/v0.31.0.tar.gz"
  sha256 "5f9bc1c89c70e852f6bc2688389e6b9822ad851250d25d0910d05fa88b842540"
  head "https://github.com/creationix/nvm.git"

  bottle :unneeded

  def install
    prefix.install "nvm.sh", "nvm-exec"
    bash_completion.install "bash_completion" => "nvm"
  end

  def caveats; <<-EOS.undent
    Please note that upstream has asked us to make explicit managing
    nvm via Homebrew is unsupported by them and you should check any
    problems against the standard nvm install method prior to reporting.

    You should create NVM's working directory if it doesn't exist:

      mkdir ~/.nvm

    Add the following to #{shell_profile} or your desired shell
    configuration file:

      export NVM_DIR=~/.nvm
      . $(brew --prefix nvm)/nvm.sh

    You can set $NVM_DIR to any location, but leaving it unchanged from
    #{prefix} will destroy any nvm-installed Node installations
    upon upgrade/reinstall.

    If upgrading from a previous version, please remember to activate the
    new version by restarting your shell or by executing the command below:

      . $(brew --prefix nvm)/nvm.sh

    Type `nvm help` for further information.
  EOS
  end

  test do
    output = pipe_output("NODE_VERSION=stable #{prefix}/nvm-exec 2>&1")
    assert_no_match /No such file or directory/, output
    assert_no_match /nvm: command not found/, output
    assert_empty output
  end
end

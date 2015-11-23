class Nvm < Formula
  desc "Manage multiple Node.js versions"
  homepage "https://github.com/creationix/nvm"
  url "https://github.com/creationix/nvm/archive/v0.29.0.tar.gz"
  sha256 "04f6f2710bc3b3820cde1055e735a6cd8fa71a3c9c2881c49c8653e982e0d86a"
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
      source $(brew --prefix nvm)/nvm.sh

    You can set $NVM_DIR to any location, but leaving it unchanged from
    #{prefix} will destroy any nvm-installed Node installations
    upon upgrade/reinstall.

    Type `nvm help` for further information.
  EOS
  end

  test do
    output = pipe_output("#{prefix}/nvm-exec 2>&1")
    assert_no_match /No such file or directory/, output
    assert_no_match /nvm: command not found/, output
    assert_match /Node Version Manager/, output
  end
end

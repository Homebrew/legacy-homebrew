class Nvm < Formula
  desc "Manage multiple Node.js versions"
  homepage "https://github.com/creationix/nvm"
  url "https://github.com/creationix/nvm/archive/v0.27.1.tar.gz"
  sha256 "74f843bf743017c086ea0c2549999afb0c81d8f5fa8bd2fdc92da37617e5b279"
  head "https://github.com/creationix/nvm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ad6e167f0094fe5a913aa27f024154acb930a3f1d2cf6ef78c43e074a3eec96" => :el_capitan
    sha256 "bda39c68500fdefd63389e2b496e41288a7d9a087f48de546f37ad7a122ba1a9" => :yosemite
    sha256 "a28caf45d1b9f65bc73493562bf3eb7191fb8c4b54fcd75cf36692446245115f" => :mavericks
    sha256 "262c46a1496abb2b060a46c19ce05eb36043e2c06c29e77f90c77d64639b2870" => :mountain_lion
  end

  def install
    prefix.install "nvm.sh", "nvm-exec"
    bash_completion.install "bash_completion" => "nvm"
  end

  def caveats; <<-EOS.undent
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

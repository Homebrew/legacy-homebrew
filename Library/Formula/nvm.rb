class Nvm < Formula
  desc "Manage multiple Node.js versions"
  homepage "https://github.com/creationix/nvm"
  url "https://github.com/creationix/nvm/archive/v0.26.1.tar.gz"
  sha256 "6add56210bd3a60517fea64eef11de01f5abfd5a23ca62c68ade9f115475b864"
  head "https://github.com/creationix/nvm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ad6e167f0094fe5a913aa27f024154acb930a3f1d2cf6ef78c43e074a3eec96" => :el_capitan
    sha256 "bda39c68500fdefd63389e2b496e41288a7d9a087f48de546f37ad7a122ba1a9" => :yosemite
    sha256 "a28caf45d1b9f65bc73493562bf3eb7191fb8c4b54fcd75cf36692446245115f" => :mavericks
    sha256 "262c46a1496abb2b060a46c19ce05eb36043e2c06c29e77f90c77d64639b2870" => :mountain_lion
  end

  resource "nvm-exec" do
    url "https://raw.githubusercontent.com/creationix/nvm/v0.26.1/nvm-exec"
    sha256 "a0581795f10114b9759992a82a43496daf4b4a52ad381a3072d8eee9866a28c5"
    version "0.26.1"
  end

  def install
    prefix.install "nvm.sh"
    bash_completion.install "bash_completion" => "nvm"

    resource("nvm-exec").stage do
      prefix.install("nvm-exec")
      chmod 0755, "#{prefix}/nvm-exec"
    end
  end

  def caveats; <<-EOS.undent
      Add NVM's working directory to your $HOME path (if it doesn't exist):

        mkdir ~/.nvm

      Copy nvm-exec to NVM's working directory

        cp $(brew --prefix nvm)/nvm-exec ~/.nvm/

      Add the following to $HOME/.bashrc, $HOME/.zshrc, or your shell's
      equivalent configuration file:

        export NVM_DIR=~/.nvm
        source $(brew --prefix nvm)/nvm.sh

      Type `nvm help` for further information.
    EOS
  end
end

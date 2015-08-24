class Nvm < Formula
  desc "Manage multiple Node.js versions"
  homepage "https://github.com/creationix/nvm"
  url "https://github.com/creationix/nvm/archive/v0.26.1.tar.gz"
  sha256 "6add56210bd3a60517fea64eef11de01f5abfd5a23ca62c68ade9f115475b864"
  head "https://github.com/creationix/nvm.git"

  bottle do
    cellar :any
    sha256 "ab9996b2ceb66f35a545e922403ab64a5010d647521d4bdbf743b3583dbd15ec" => :yosemite
    sha256 "db4e26b82f10a0585b62d35fa3ef7c55d0e9b4ecd48e8a8b4f625f993e6036b5" => :mavericks
    sha256 "7b1de04a747bfd4bcd6403a70b5907be8d782ebb11c9bdcaaab9a952c2eb8289" => :mountain_lion
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

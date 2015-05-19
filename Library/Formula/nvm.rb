class Nvm < Formula
  desc "Manage multiple Node.js versions"
  homepage "https://github.com/creationix/nvm"
  url "https://github.com/creationix/nvm/archive/v0.25.4.tar.gz"
  sha256 "6df007c5e9e36a8409f3daeced1d50d66b0d03ebecd780533d4546c519d351a7"
  head "https://github.com/creationix/nvm.git"

  resource "nvm-exec" do
    url "https://raw.githubusercontent.com/creationix/nvm/v0.25.4/nvm-exec"
    sha256 "a0581795f10114b9759992a82a43496daf4b4a52ad381a3072d8eee9866a28c5"
    version "0.25.4"
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

class Nvm < Formula
  homepage "https://github.com/creationix/nvm"
  url "https://github.com/creationix/nvm/archive/v0.24.1.tar.gz"
  sha256 "0008754e7421c55e66f36c4a83ca775928f7b2e7a0543098f0050d9780419b2a"
  head "https://github.com/creationix/nvm.git"

  def install
    prefix.install "nvm.sh"
    bash_completion.install "bash_completion" => "nvm"
  end

  def caveats; <<-EOS.undent
      Add NVM's working directory to your $HOME path (if it doesn't exist):

        mkdir ~/.nvm

      Add the following to $HOME/.bashrc, $HOME/.zshrc, or your shell's
      equivalent configuration file:

        export NVM_DIR=~/.nvm
        source $(brew --prefix nvm)/nvm.sh

      Type `nvm help` for further information.
    EOS
  end
end

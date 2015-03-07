class Nvm < Formula
  homepage "https://github.com/creationix/nvm"
  url "https://github.com/creationix/nvm/archive/v0.24.0.tar.gz"
  sha256 "f76800f248ebe611c8c2588553cc906d335baafbfd083ee6fdedee349a979c54"
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

class Nvm < Formula
  homepage "https://github.com/creationix/nvm"
  head "https://github.com/creationix/nvm.git"
  url "https://github.com/creationix/nvm/archive/v0.23.3.tar.gz"
  sha1 "f40c9e766fb98ff32987944063c2b9b4a203b954"

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

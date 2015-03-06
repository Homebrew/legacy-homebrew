class Nvm < Formula
  homepage "https://github.com/creationix/nvm"
  url "https://github.com/creationix/nvm/archive/v0.24.0.tar.gz"
  sha256 "f76800f248ebe611c8c2588553cc906d335baafbfd083ee6fdedee349a979c54"
  head "https://github.com/creationix/nvm.git"

  bottle do
    cellar :any
    sha256 "efaf140cac680e83807172d177d09c53720e9253dc21aa4264b13921bb7d2267" => :yosemite
    sha256 "d7de5b13f7be5f0e2e1900136ce85756cf29a01ed01d86ec879baa30b1fb623c" => :mavericks
    sha256 "ccdca35f48abebdb064c3940df4c3d4f508fb4fe79c7184ab7c566ee93886873" => :mountain_lion
  end

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

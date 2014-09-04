require "formula"

class Nvm < Formula
  homepage "https://github.com/creationix/nvm"
  head "https://github.com/creationix/nvm.git"
  url "https://github.com/creationix/nvm/archive/v0.15.0.tar.gz"
  sha1 "87f98661ca3168e3dc7a230ad7e20132e8b760e4"

  def install
    prefix.install "nvm.sh"
    bash_completion.install "bash_completion" => "nvm"
  end

  def caveats; <<-EOS.undent
      Add the following to $HOME/.bashrc, $HOME/.zshrc, or your shell's
      equivalent configuration file:

        source $(brew --prefix nvm)/nvm.sh

      Node installs will be lost upon upgrading nvm. Add the following above
      the source line to move install location and prevent this:

        export NVM_DIR=~/.nvm

      Type `nvm help` for further information.
    EOS
  end
end

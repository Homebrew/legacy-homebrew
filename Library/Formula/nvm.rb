require "formula"

class Nvm < Formula
  homepage "https://github.com/creationix/nvm"
  head "https://github.com/creationix/nvm.git"
  url "https://github.com/creationix/nvm/archive/v0.17.3.tar.gz"
  sha1 "e77d1441196b8efeb9b981e5f7873a2f0871fbdb"

  def install
    prefix.install "nvm.sh"
    bash_completion.install "bash_completion" => "nvm"
  end

  def caveats; <<-EOS.undent
      Node installs will be lost upon upgrading nvm. Add the following to
      $HOME/.bashrc, $HOME/.zshrc, or your shell's equivalent configuration
      file to move install location and prevent this:

        export NVM_DIR=~/.nvm
        
      Add the following above the export line:

        source $(brew --prefix nvm)/nvm.sh

      Type `nvm help` for further information.
    EOS
  end
end

require 'formula'

class Nvm < Formula
  homepage 'https://github.com/creationix/nvm'
  head 'https://github.com/creationix/nvm.git'
  url 'https://github.com/creationix/nvm/archive/v0.5.0.tar.gz'
  sha1 'c66c6f1f227ef4de0e48b48f1fb5f0ef18f54a06'

  def install
    prefix.install 'nvm.sh'
    bash_completion.install 'bash_completion' => 'nvm'
  end

  def caveats;
    <<-EOS.undent
      Add the following to $HOME/.bashrc, $HOME/.zshrc, or your shell's equivalent configuration file:

        source $(brew --prefix nvm)/nvm.sh

      Type `nvm help` for further information.
    EOS
  end
end

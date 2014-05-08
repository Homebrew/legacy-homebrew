require 'formula'

class Nvm < Formula
  homepage 'https://github.com/creationix/nvm'
  head 'https://github.com/creationix/nvm.git'
  url 'https://github.com/creationix/nvm/archive/v0.6.1.tar.gz'
  sha1 '0b5e70dd4531f7526afd6c9417f2e4ce17cb46bc'

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

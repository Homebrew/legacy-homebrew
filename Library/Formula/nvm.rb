require 'formula'

class Nvm < Formula
  homepage 'https://github.com/creationix/nvm'
  head 'https://github.com/creationix/nvm.git'
  url 'https://github.com/creationix/nvm/archive/v0.4.0.tar.gz'
  sha1 'e96833c0a7d1611a8cf70a0fd47321aec17f6ca4'

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

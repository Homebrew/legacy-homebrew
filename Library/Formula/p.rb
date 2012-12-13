require 'formula'

class P < Formula
  homepage 'https://github.com/hhallman/p'
  url 'https://github.com/hhallman/p/tarball/v0.1'
  version '0.1'
  sha1 '94fed46e93939fea3cc70c048e120112466c1945'

  head 'https://github.com/hhallman/p.git'

  def install
    (prefix+'etc/profile.d').install 'p.sh'
  end

  def caveats; <<-EOS.undent
    For Bash, put something like this in your $HOME/.bashrc or $HOME/.zshrc:

     . `brew --prefix`/etc/profile.d/p.sh
    EOS
  end
end

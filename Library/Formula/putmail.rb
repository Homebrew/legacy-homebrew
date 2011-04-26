require 'formula'

class Putmail < Formula
  url 'http://downloads.sourceforge.net/project/putmail/putmail.py/1.4/putmail.py-1.4.tar.bz2'
  homepage 'http://putmail.sourceforge.net/home.html'
  md5 'cb512effdb98731821b09dedcbc641ed'

  def install
    # Install manually.
    bin.install "putmail.py"
    man1.install "man/man1/putmail.py.1"

    # MacPorts does this, so why not
    ln_s bin+"putmail.py", bin+"putmail"
    ln_s man1+"putmail.py.1", man1+"putmail.1"
  end
end

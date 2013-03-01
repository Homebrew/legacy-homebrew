require 'formula'

class Putmail < Formula
  homepage 'http://putmail.sourceforge.net/home.html'
  url 'http://downloads.sourceforge.net/project/putmail/putmail.py/1.4/putmail.py-1.4.tar.bz2'
  sha1 '7903fd32a14192adb72560b99c01e6563bc9dd38'

  def install
    # Install manually.
    bin.install "putmail.py"
    man1.install "man/man1/putmail.py.1"

    # MacPorts does this, so why not
    ln_s bin+"putmail.py", bin+"putmail"
    ln_s man1+"putmail.py.1", man1+"putmail.1"
  end
end

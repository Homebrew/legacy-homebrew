require 'formula'

class Putmail < Formula
  homepage 'http://putmail.sourceforge.net/home.html'
  url 'https://downloads.sourceforge.net/project/putmail/putmail.py/1.4/putmail.py-1.4.tar.bz2'
  sha1 '7903fd32a14192adb72560b99c01e6563bc9dd38'

  def install
    bin.install "putmail.py"
    man1.install "man/man1/putmail.py.1"
    bin.install_symlink "putmail.py" => "putmail"
    man1.install_symlink "putmail.py.1" => "putmail.1"
  end
end

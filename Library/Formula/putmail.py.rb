require 'formula'

class PutmailPy < Formula
  url 'http://downloads.sourceforge.net/project/putmail/putmail.py/1.4/putmail.py-1.4.tar.bz2'
  homepage 'http://putmail.sourceforge.net/home.html'
  md5 'cb512effdb98731821b09dedcbc641ed'

  def install
    system "export PREFIX=#{prefix};./install.sh"
  end
end

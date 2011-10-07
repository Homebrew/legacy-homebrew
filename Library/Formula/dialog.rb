require 'formula'

class Dialog < Formula
  url 'ftp://invisible-island.net/dialog/dialog.tar.gz'
  homepage 'http://invisible-island.net/dialog/'
  md5 '34d01aaacbb2932b77774e6c1eec8d2a'
  version '1.1.20110707'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end

require 'formula'

class Dialog < Formula
  url 'ftp://invisible-island.net/dialog/dialog.tar.gz'
  homepage 'http://invisible-island.net/dialog/'
  md5 '2eaa82055b86006e205d2c3f74d9b800'
  version '1.1.20110302'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end

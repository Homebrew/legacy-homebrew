require 'formula'

class Dialog < Formula
  url 'ftp://invisible-island.net/dialog/dialog.tar.gz'
  homepage 'http://invisible-island.net/dialog/'
  md5 '15dd2ce9f537c0400f600d1a383aa0a3'
  version '1.1.20111020'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end

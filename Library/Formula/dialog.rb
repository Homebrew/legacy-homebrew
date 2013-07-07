require 'formula'

class Dialog < Formula
  homepage 'http://invisible-island.net/dialog/'
  url 'ftp://invisible-island.net/dialog/dialog-1.2-20121230.tgz'
  sha1 'f6ba16481e04c707c7cbfc3c3c1340040bdb0aa3'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end

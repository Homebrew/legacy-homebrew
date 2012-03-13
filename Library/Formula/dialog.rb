require 'formula'

class Dialog < Formula
  homepage 'http://invisible-island.net/dialog/'
  url 'ftp://invisible-island.net/dialog/dialog-1.1-20120215.tgz'
  sha1 '0d8a07e064c6d4f9cc7d9cb21c4609dc4a19537e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end

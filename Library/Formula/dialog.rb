require 'formula'

class Dialog < Formula
  homepage 'http://invisible-island.net/dialog/'
  url 'ftp://invisible-island.net/dialog/dialog-1.2-20130928.tgz'
  sha1 '204d852856754817f5590f60ffaa1c07a8ed35ca'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end

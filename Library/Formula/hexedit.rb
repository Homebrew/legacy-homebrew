require 'formula'

class Hexedit < Formula
  homepage 'http://rigaux.org/hexedit.html'
  url 'http://rigaux.org/hexedit-1.2.13.src.tgz'
  sha1 '1acb7ca37063d9f4b4d118ef223548fde3b753f1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end

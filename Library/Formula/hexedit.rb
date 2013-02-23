require 'formula'

class Hexedit < Formula
  homepage 'http://rigaux.org/hexedit.html'
  url 'http://rigaux.org/hexedit-1.2.12.src.tgz'
  sha1 'fee89e390945045fe6b74b5f07600a8e664c8b21'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end

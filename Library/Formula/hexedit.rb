require 'formula'

class Hexedit < Formula
  url 'http://rigaux.org/hexedit-1.2.12.src.tgz'
  homepage 'http://rigaux.org/hexedit.html'
  md5 '0d2f48610006278cd93359fea9a06d5c'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end

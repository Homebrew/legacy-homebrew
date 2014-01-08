require 'formula'

class Cabextract < Formula
  homepage 'http://www.cabextract.org.uk/'
  url 'http://www.cabextract.org.uk/cabextract-1.4.tar.gz'
  sha1 'b1d5dd668d2dbe95b47aad6e92c0b7183ced70f1'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end

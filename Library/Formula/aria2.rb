require 'formula'

class Aria2 < Formula
  url 'http://downloads.sourceforge.net/project/aria2/stable/aria2-1.12.0/aria2-1.12.0.tar.bz2'
  md5 '3611fd4d63821162aa47ae113a7858b2'
  homepage 'http://aria2.sourceforge.net/'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

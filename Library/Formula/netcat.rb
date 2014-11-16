require 'formula'

class Netcat < Formula
  homepage 'http://netcat.sourceforge.net/'
  url 'https://downloads.sourceforge.net/sourceforge/netcat/netcat-0.7.1.tar.bz2'
  sha1 'b761d70fe9e3e8b3fe33a329b9bc31300dc04d11'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make install"
  end
end

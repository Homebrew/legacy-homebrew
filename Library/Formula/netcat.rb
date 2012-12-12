require 'formula'

class Netcat < Formula
  url 'http://downloads.sourceforge.net/sourceforge/netcat/netcat-0.7.1.tar.bz2'
  sha1 'b761d70fe9e3e8b3fe33a329b9bc31300dc04d11'
  homepage 'http://netcat.sourceforge.net/'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make install"
  end
end

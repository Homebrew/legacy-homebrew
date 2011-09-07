require 'formula'

class Netcat < Formula
  url 'http://downloads.sourceforge.net/sourceforge/netcat/netcat-0.7.1.tar.bz2'
  md5 '0a29eff1736ddb5effd0b1ec1f6fe0ef'
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

require 'formula'

class Csvprintf < Formula
  homepage 'http://code.google.com/p/csvprintf/'
  url 'http://csvprintf.googlecode.com/files/csvprintf-1.0.2.tar.gz'
  sha1 '3ecc01ead2e870c12bd9002c179ed16e9c6fa6bf'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

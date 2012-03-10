require 'formula'

class Gmock < Formula
  url 'http://googlemock.googlecode.com/files/gmock-1.5.0.tar.bz2'
  homepage 'http://code.google.com/p/googlemock/'
  md5 'd738cfee341ad10ce0d7a0cc4209dd5e'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end

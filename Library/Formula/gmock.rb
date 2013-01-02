require 'formula'

class Gmock < Formula
  url 'http://googlemock.googlecode.com/files/gmock-1.5.0.tar.bz2'
  homepage 'http://code.google.com/p/googlemock/'
  sha1 '76d8f5a221c93105304d71e33391dc70af573d6a'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end

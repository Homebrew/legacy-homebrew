require 'formula'

class Leptonica < Formula
  url 'http://leptonica.googlecode.com/files/leptonlib-1.65.tar.gz'
  homepage 'http://code.google.com/p/leptonica/'
  md5 '5dd42b2337834cc796b8f8de7ab532cd'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

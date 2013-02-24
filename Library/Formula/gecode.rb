require 'formula'

class Gecode < Formula
  homepage 'http://www.gecode.org/'
  url 'http://www.gecode.org/download/gecode-3.7.3.tar.gz'
  sha1 'f9281a80788cd0c0f0495cd6145fe4bf9ee74117'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-examples"
    system "make install"
  end
end

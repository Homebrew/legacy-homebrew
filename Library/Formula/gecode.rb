require 'formula'

class Gecode < Formula
  homepage 'http://www.gecode.org/'
  url 'http://www.gecode.org/download/gecode-4.3.3.tar.gz'
  sha1 '392f079979a582e040ff1d58736f23e985ca53ff'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-examples"
    system "make install"
  end
end

require 'formula'

class Gecode < Formula
  homepage 'http://www.gecode.org/'
  url 'http://www.gecode.org/download/gecode-4.0.0.tar.gz'
  sha1 'a1137f89fd527d47d183b3d8e38bc5d52a65b954'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-examples"
    system "make install"
  end
end

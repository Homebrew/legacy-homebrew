require 'formula'

class Raptor < Formula
  url 'http://download.librdf.org/source/raptor2-2.0.2.tar.gz'
  homepage 'http://librdf.org/raptor/'
  md5 'b0f874c200c4b3214b5bf4806ae82353'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

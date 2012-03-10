require 'formula'

class Libsvg < Formula
  url 'http://cairographics.org/snapshots/libsvg-0.1.4.tar.gz'
  homepage 'http://cairographics.org/'
  md5 'ce0715e3013f78506795fba16e8455d3'

  depends_on 'jpeg'

  def install
    ENV.x11 # for libpng
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

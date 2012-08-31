require 'formula'

class Webp < Formula
  homepage 'http://code.google.com/speed/webp/'
  url 'http://webp.googlecode.com/files/libwebp-0.2.0.tar.gz'
  sha1 'ac169a819cb4e7ece8d50d3f9f2608dac87a90e2'

  depends_on :x11
  depends_on 'jpeg'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

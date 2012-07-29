require 'formula'

class Webp < Formula
  homepage 'http://code.google.com/speed/webp/'
  url 'http://webp.googlecode.com/files/libwebp-0.1.99.tar.gz'
  sha1 '20c4d471601c44c9dcabe116eca3573a0aab5289'

  depends_on :x11
  depends_on 'jpeg'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

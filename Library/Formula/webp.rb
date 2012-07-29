require 'formula'

class Webp < Formula
  url 'http://webp.googlecode.com/files/libwebp-0.1.99.tar.gz'
  homepage 'http://code.google.com/speed/webp/'
  sha1 '20c4d471601c44c9dcabe116eca3573a0aab5289'

  depends_on :x11
  depends_on 'jpeg'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end

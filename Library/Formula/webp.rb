require 'formula'

class Webp < Formula
  url 'http://webp.googlecode.com/files/libwebp-0.1.3.tar.gz'
  homepage 'http://code.google.com/speed/webp/'
  md5 '254d4670e14e9ed881f0536b006ab336'

  depends_on :x11
  depends_on 'jpeg'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end

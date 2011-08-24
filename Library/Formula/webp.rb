require 'formula'

class Webp < Formula
  url 'http://webp.googlecode.com/files/libwebp-0.1.2.tar.gz'
  homepage 'http://code.google.com/speed/webp/'
  md5 '5534f6e3c8b9f5851a9a5b56bf78f2b0'

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

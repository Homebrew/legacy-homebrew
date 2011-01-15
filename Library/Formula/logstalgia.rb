require 'formula'

class Logstalgia <Formula
  url 'http://logstalgia.googlecode.com/files/logstalgia-1.0.0.tar.gz'
  homepage 'http://code.google.com/p/logstalgia/'
  md5 '606ba346d34a6cc6e4cdf716130df510'

  depends on "ftgl"
  depends on "jpeg"
  depends on "libpng"
  depends on "pcre"
  depends on "sdl"
  depends on "sdl_image"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make install"
  end
end

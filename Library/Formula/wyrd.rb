require 'formula'

class Wyrd < Formula
  url 'http://pessimization.com/software/wyrd/wyrd-1.4.5.tar.gz'
  homepage 'http://pessimization.com/software/wyrd/'
  md5 '3f39fa83a54d2d890823094aba9ca3cc'

  depends_on 'remind'
  depends_on 'objective-caml'

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-utf8"
    system "make"
    system "make install"
  end
end

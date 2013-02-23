require 'formula'

class Wyrd < Formula
  homepage 'http://pessimization.com/software/wyrd/'
  url 'http://pessimization.com/software/wyrd/wyrd-1.4.5.tar.gz'
  sha1 '97b6c03ca532e5c209c112f5fb050cafbcecce6d'

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

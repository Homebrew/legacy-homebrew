require 'formula'

class Wyrd < Formula
  homepage 'http://pessimization.com/software/wyrd/'
  url 'http://pessimization.com/software/wyrd/wyrd-1.4.6.tar.gz'
  sha1 'aaeca29b844825f45aadcf5207f4d1c875e4dc82'

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

require 'formula'

class Kite < Formula
  url 'http://www.kite-language.org/files/kite-1.0.3.tar.gz'
  homepage 'http://www.kite-language.org/'
  md5 '2cfa1a7249f9847accac3bbe9e1c1b91'

  depends_on 'bdw-gc'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

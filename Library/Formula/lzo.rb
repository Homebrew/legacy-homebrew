require 'formula'

class Lzo < Formula
  homepage 'http://www.oberhumer.com/opensource/lzo/'
  url 'http://www.oberhumer.com/opensource/lzo/download/lzo-2.05.tar.gz'
  sha256 '449f98186d76ba252cd17ff1241ca2a96b7f62e0d3e4766f88730dab0ea5f333'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-asm",
                          "--enable-shared=yes"
    system "make install"
  end
end

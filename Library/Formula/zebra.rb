require 'formula'

class Zebra < Formula
  homepage 'http://www.indexdata.com/zebra'
  url 'http://ftp.indexdata.dk/pub/zebra/idzebra-2.0.54.tar.gz'
  sha1 '55c555606387f42d5dc641151fa8b2c62c5fa21b'

  depends_on 'yaz'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-mod-text",
                          "--enable-mod-grs-regx",
                          "--enable-mod-grs-marc",
                          "--enable-mod-grs-xml",
                          "--enable-mod-dom",
                          "--enable-mod-alvis",
                          "--enable-mod-safari"
    system "make install"
  end
end

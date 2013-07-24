require 'formula'

class Zebra < Formula
  homepage 'http://www.indexdata.com/zebra'
  url 'http://ftp.indexdata.dk/pub/zebra/idzebra-2.0.55.tar.gz'
  sha1 '14b600e3d1ac1505965bef7e7ddcf223ef714d28'

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

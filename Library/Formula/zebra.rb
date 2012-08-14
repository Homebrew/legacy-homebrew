require 'formula'

class Zebra < Formula
  url 'http://ftp.indexdata.dk/pub/zebra/idzebra-2.0.52.tar.gz'
  homepage 'http://www.indexdata.com/zebra'
  sha1 '11b12bbad9b16250bc29f58092bc368d91345e7b'

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

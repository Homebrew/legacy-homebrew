require 'formula'

class Zebra < Formula
  homepage 'http://www.indexdata.com/zebra'
  url 'http://ftp.indexdata.dk/pub/zebra/idzebra-2.0.56.tar.gz'
  sha1 '782655c42d892b3cd00672b46d67b1c689b771ad'

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

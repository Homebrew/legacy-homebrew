require 'formula'

class Zebra < Formula
  homepage 'http://www.indexdata.com/zebra'
  url 'http://ftp.indexdata.dk/pub/zebra/idzebra-2.0.53.tar.gz'
  sha1 'e8a819250adfd5c3af37d066ebffd5b82c6c55da'

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

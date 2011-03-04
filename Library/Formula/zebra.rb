require 'formula'

class Zebra <Formula
  url 'http://ftp.indexdata.dk/pub/zebra/idzebra-2.0.44.tar.gz'
  homepage 'http://www.indexdata.com/zebra'
  md5 'aa7562e0a1bff05d79893c128bfde35e'

  depends_on 'yaz'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
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

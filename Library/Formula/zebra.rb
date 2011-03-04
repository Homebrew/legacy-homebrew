require 'formula'

class Zebra <Formula
  url 'http://ftp.indexdata.dk/pub/zebra/idzebra-2.0.45.tar.gz'
  homepage 'http://www.indexdata.com/zebra'
  md5 '50aa282d76b4fa86a02c28e6dad4e24b'

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

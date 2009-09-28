require 'brewkit'

class Zebra <Formula
  url 'http://ftp.indexdata.dk/pub/zebra/idzebra-2.0.41.tar.gz'
  homepage 'http://www.indexdata.com/zebra'
  md5 'a96db171add2bfc0a38833df794069fb'

  depends_on 'yaz'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
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

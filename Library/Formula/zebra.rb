require 'formula'

class Zebra < Formula
  homepage 'http://www.indexdata.com/zebra'
  url 'http://ftp.indexdata.dk/pub/zebra/idzebra-2.0.58.tar.gz'
  sha1 'c810949e57d86d536ca36145afe6d4f21a04bb61'

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

class Zebra < Formula
  homepage "http://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.0.60.tar.gz"
  sha256 "9eac55475ebf52bf0ca9d66b45a0566b91bfa3e27e12dd23f030e23bab920c33"

  depends_on "yaz"

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
    system "make", "install"
  end

  test do
    cd share/"idzebra-2.0-examples/oai-pmh/" do
      system "zebraidx-2.0", "-c", "conf/zebra.cfg", "init"
      system "zebraidx-2.0", "-c", "conf/zebra.cfg", "commit"
    end
  end
end

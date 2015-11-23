class Zebra < Formula
  desc "Information management system"
  homepage "http://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.0.60.tar.gz"
  sha256 "9eac55475ebf52bf0ca9d66b45a0566b91bfa3e27e12dd23f030e23bab920c33"
  revision 1

  bottle do
    sha256 "cb8719b57d263da8d4f2762609b52d197e84194c4064d78b891fe52d445f389d" => :yosemite
    sha256 "2ab063082c73c5d57fb221f886074025faa5c863693b77ceed9bf8fb761eb3b0" => :mavericks
    sha256 "43223a086858dfa6283481fdd954e7cb9e6f20de9b174c5ab3e7a6a49167a838" => :mountain_lion
  end

  depends_on "icu4c" => :recommended
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

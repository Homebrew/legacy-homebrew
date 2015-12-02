class Zebra < Formula
  desc "Information management system"
  homepage "http://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.0.61.tar.gz"
  sha256 "e3e5d3c50500847c4d065c93108ab9fd0222a8dbddc12565090cfdd8a885cf6f"

  bottle do
    sha256 "ea1468fb5965b2ad918523f3878d8f469a610424a2e9ecd006defd43a2336cdd" => :el_capitan
    sha256 "8525515404a8b4f2055b0e462d688d23901c8924290def3c415bf2122d4361df" => :yosemite
    sha256 "94f617a9e7407c0a9f51b9254440ece883942428adec840b2a0f0439d4c4286e" => :mavericks
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

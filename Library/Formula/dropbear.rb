class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2015.67.tar.bz2"
  sha256 "7e690594645dfde5787065c78a5d2e4d15e288babfa06e140197ce05f698c8e5"

  bottle do
    cellar :any
    sha256 "c8e9ed7751d8c0c4ae6f4c042f063967c86ca42675cd742c52617e0cdd1ae0ed" => :yosemite
    sha256 "3161e412ab4dd042dfffc26b62409c467f184488178f58df168cb4c9e074c400" => :mavericks
    sha256 "16396c8c4d6aff45e1d32757bd96b8a9806d2a282a3cd21a37e191efe0b0be7d" => :mountain_lion
  end

  head do
    url "https://github.com/mkj/dropbear.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    ENV.deparallelize

    if build.head?
      system "autoconf"
      system "autoheader"
    end
    system "./configure", "--prefix=#{prefix}",
                          "--enable-pam",
                          "--enable-zlib",
                          "--enable-bundled-libtom",
                          "--sysconfdir=#{etc}/dropbear"
    system "make"
    system "make", "install"
  end

  test do
    system "dbclient", "-h"
    system "dropbearkey", "-t", "ecdsa",
           "-f", testpath/"testec521", "-s", "521"
    File.exist? testpath/"testec521"
  end
end

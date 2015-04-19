class Dropbear < Formula
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2015.67.tar.bz2"
  sha256 "7e690594645dfde5787065c78a5d2e4d15e288babfa06e140197ce05f698c8e5"

  bottle do
    cellar :any
    sha1 "b7fc99831d70610973f7978fdbfdd170c562c93b" => :yosemite
    sha1 "1b52833468598772dc72b08defe5bfe8d592f9a1" => :mavericks
    sha1 "3665d3c991cc865f6d2de2b7b3268ed6040a2a26" => :mountain_lion
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

class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.1.4/libmaxminddb-1.1.4.tar.gz"
  sha256 "fb618d22f9dd3494faf860e82e75e4e1f4cc14410a01118feb7bb7c31ea089a4"

  bottle do
    cellar :any
    sha256 "bd04c58706f4c68015dae96d308c753a0ced1a368cbe040be722a91e17f5a845" => :el_capitan
    sha256 "9bf7679b5ae37940c2b90f94d60bd56b7c1dc88d616a84777b65204ae45f9c2c" => :yosemite
    sha256 "1ead29330b20b2a075ab2cfe28425dd38868c402b5823a841e168c0672555104" => :mavericks
  end

  head do
    url "https://github.com/maxmind/libmaxminddb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "geoipupdate" => :optional

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./bootstrap" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
    (share/"examples").install buildpath/"t/maxmind-db/test-data/GeoIP2-City-Test.mmdb"
  end

  test do
    system "#{bin}/mmdblookup", "-f", "#{share}/examples/GeoIP2-City-Test.mmdb",
                                "-i", "175.16.199.0"
  end
end

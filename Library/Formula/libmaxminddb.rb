class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.2.0/libmaxminddb-1.2.0.tar.gz"
  sha256 "1fe859ed714f94fc902a145453f7e1b5cd928718179ba4c4fcb7f6ae0df7ad37"

  bottle do
    cellar :any
    sha256 "626d41d5b47374ce9bdd046e1b958ab68536efd772ebd0ad0949e453589ced39" => :el_capitan
    sha256 "345c405bbdcfa1fad247e838f594b522b935e41ddbf7b7760e7404121a3475f3" => :yosemite
    sha256 "9046beb8d9abb5002e367594b39ca4fd5e121ca9977cc37e07437c5b8a684a80" => :mavericks
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

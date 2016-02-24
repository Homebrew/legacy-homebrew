class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.1.4/libmaxminddb-1.1.4.tar.gz"
  sha256 "fb618d22f9dd3494faf860e82e75e4e1f4cc14410a01118feb7bb7c31ea089a4"

  bottle do
    cellar :any
    sha256 "27dc75aea9488cc109f8e67b7c1ee8835b103c19ad9605315e93df38613cd6db" => :el_capitan
    sha256 "f3efd2c1aac7c9aaac0b0e2214a97fa5ed596d909a7121550a9faeca30074b18" => :yosemite
    sha256 "b63e0fc568a48f88a55ec33ea11710eeea71696ed2dd5d6bc46050edf48689c8" => :mavericks
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

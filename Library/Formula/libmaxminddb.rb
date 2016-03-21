class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.1.5/libmaxminddb-1.1.5.tar.gz"
  sha256 "655397037a70a08b276500f67c0f95f315f1a84809d6a5742593eb2720717d8a"

  bottle do
    cellar :any
    sha256 "a05eec1703d5d58cae7455ae397fc3d2fa3514e27b32aa3f4bf8d195d99390ff" => :el_capitan
    sha256 "6b85890ea8726bd53c5a574a4d883eddb3fc8c9cddcad41b54a126ef94d87050" => :yosemite
    sha256 "49841b6972f85c952a7e26ea144d4a2cf28390524a59c6e42140834e46edd7fc" => :mavericks
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

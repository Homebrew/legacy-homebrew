class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.1.1/libmaxminddb-1.1.1.tar.gz"
  sha256 "60060bc081573220d4633e4cbb26f999521c0f197304bc7f5ea700fc26ef2276"

  bottle do
    cellar :any
    sha256 "62326c381b6656b8828fbacfdf02df9c674cb98fc6c8cfe4f3e1908cd933bb52" => :el_capitan
    sha256 "f5356fa88e5f46074c2037d67e514f7ca1d2856618f3657da54df457a6b0b03c" => :yosemite
    sha256 "7fbf6931665e63ce247c7aef488efcb3d58b98a511fc67f20fdfb1bc7c4a3acc" => :mavericks
    sha256 "017af226ff521f3486f7ae40c318c5ee7c9da5b18f9c02b74d69a0d0826c254b" => :mountain_lion
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

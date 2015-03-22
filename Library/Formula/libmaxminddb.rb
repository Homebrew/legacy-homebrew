class Libmaxminddb < Formula
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.0.4/libmaxminddb-1.0.4.tar.gz"
  sha1 "57548d426d43b9b43c77786b08594d48d0c88c62"

  bottle do
    cellar :any
    revision 1
    sha1 "9ef726ff11d9933e9aa1df2ce8adc21493714259" => :yosemite
    sha1 "0e3a37a3ad55d27220ec49ee653016ecc649d952" => :mavericks
    sha1 "3888352b39e903d2f30d6947db0c041ecaa3540a" => :mountain_lion
  end

  head do
    url "https://github.com/maxmind/libmaxminddb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "geoipupdate" => :optional

  # This patch is from an upstream post-1.0.4 commit and fixes a test failure
  # on OS X. See https://github.com/maxmind/libmaxminddb/commit/424953
  patch do
    url "https://github.com/maxmind/libmaxminddb/commit/424953.diff"
    sha1 "362cf3254145188dc9959651ba7ee876007998c9"
  end

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
  end

  test do
    system "curl", "-O", "http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz"
    system "gunzip", "GeoLite2-Country.mmdb.gz"
    system "#{bin}/mmdblookup", "-f", "GeoLite2-Country.mmdb",
                                "-i", "8.8.8.8"
  end
end

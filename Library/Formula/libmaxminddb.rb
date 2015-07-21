class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.1.0/libmaxminddb-1.1.0.tar.gz"
  sha1 "11ba150829d2cf169202426932daaf112bb63695"

  bottle do
    cellar :any
    sha256 "f923147f3aacda41439e72737c22899356b11d61f2c9628839bac361d365a57e" => :yosemite
    sha256 "ffc9884a7818e4b31b0a4d7e7a2d9edb10de783039b3ee4a20084a91373447ea" => :mavericks
    sha256 "1c3da6449a58c7f2840b51dd0de405b1d27a6d3c8ae211d0a6f38a21a17f780a" => :mountain_lion
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
  end

  test do
    system "curl", "-O", "http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz"
    system "gunzip", "GeoLite2-Country.mmdb.gz"
    system "#{bin}/mmdblookup", "-f", "GeoLite2-Country.mmdb",
                                "-i", "8.8.8.8"
  end
end

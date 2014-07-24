require "formula"

class Geoipupdate < Formula
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/releases/download/v2.0.2/geoipupdate-2.0.2.tar.gz"
  sha1 "14274698cacb5468475a008b8db61e162ff1ce73"

  head do
    url "https://github.com/maxmind/geoipupdate.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    # Download free databases by default
    # See https://github.com/maxmind/geoip-api-c#150
    inreplace "conf/GeoIP.conf.default", "YOUR_USER_ID_HERE", "999999"
    inreplace "conf/GeoIP.conf.default", "YOUR_LICENSE_KEY_HERE", "000000000000"
    inreplace "conf/GeoIP.conf.default", /^ProductIds .*$/, "ProductIds 506 533"

    system "./bootstrap" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--datadir=#{var}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    (var/"GeoIP").mkpath
  end

  test do
    system "#{bin}/geoipupdate", "-v"
  end
end

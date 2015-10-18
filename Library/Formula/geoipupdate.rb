class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/releases/download/v2.2.1/geoipupdate-2.2.1.tar.gz"
  sha256 "9547c42cc8620b2c3040fd8df95e8ee45c8b6ebcca7737d641f9526104d5f446"

  bottle do
    sha256 "a3313c0df356e2fbc6eea2a46862c34efb88206931d2452ca45b1bba471a284b" => :el_capitan
    sha256 "bf6ff091c8e3ad9529d0cbd39f7380e1cd2379137684b508c8e70799a0e1feb2" => :yosemite
    sha256 "175eaccb4fad21fcd9bb64f9fc1997d450c8c66b4146544d27180b57e2eaace8" => :mavericks
    sha256 "d24c71e19f810f252619df4a183da690e8b0fb97943adcae5b35405b11595c43" => :mountain_lion
  end

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
    inreplace "conf/GeoIP.conf.default", /^ProductIds .*$/, "ProductIds 506 533 GeoLite2-City GeoLite2-Country"

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

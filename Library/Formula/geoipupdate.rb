class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/releases/download/v2.2.2/geoipupdate-2.2.2.tar.gz"
  sha256 "156ab7604255a9c62c4a442c76d48d024ac813c6542639bffa93b28e2a781621"

  bottle do
    sha256 "0e69897d110e62e85a16536ee88955bd99ec20e428436f02253b8017535f5c48" => :el_capitan
    sha256 "3cb6006adb116784d3aec5415be409feb2d663595fa05defab110d5856029b8b" => :yosemite
    sha256 "5738a8729ef6111da261f11d7819d614d3d22c48d0261caea89b12b668b62a7e" => :mavericks
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
    system "#{bin}/geoipupdate", "-V"
  end
end

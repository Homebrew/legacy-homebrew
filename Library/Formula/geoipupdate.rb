class Geoipupdate < Formula
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/releases/download/v2.1.0/geoipupdate-2.1.0.tar.gz"
  sha1 "3b77c88d43ab7ad5056cbd5bc2f557b193fa5100"

  bottle do
    sha1 "38fee37aa1dec793929bbd02d6fb9165d076172e" => :yosemite
    sha1 "9e3b01045af204b08852cf95ed79ec34c400343d" => :mavericks
    sha1 "fa0ad3c890c31f506b4c980fc6b702457b56eb68" => :mountain_lion
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

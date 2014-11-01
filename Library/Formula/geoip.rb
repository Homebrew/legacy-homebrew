require "formula"

class Geoip < Formula
  homepage "https://github.com/maxmind/geoip-api-c"

  stable do
    url "https://github.com/maxmind/geoip-api-c/archive/v1.6.3.tar.gz"
    sha1 "7561dcb5ba928a3f190426709063829093283c32"
  end

  head "https://github.com/maxmind/geoip-api-c.git"

  bottle do
    cellar :any
    revision 2
    sha1 "d3379a5450e8ab5696f72a4d901ad122a63c4029" => :yosemite
    sha1 "0d9bb56a2b6b950f566c86208af7a53426e1de99" => :mavericks
    sha1 "9f6129ef37af7af53c3f66c87ce20f753bfdbf0c" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "geoipupdate" => :optional

  option :universal

  def install
    ENV.universal_binary if build.universal?

    # Fixes a build error on Lion when configure does a variant of autoreconf
    # that results in a botched Makefile, causing this error:
    # No rule to make target '../libGeoIP/libGeoIP.la', needed by 'geoiplookup'
    # This works on Snow Leopard also when it tries but fails to run autoreconf.
    # Also fixes the tests by downloading required data file
    system "./bootstrap"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--datadir=#{var}",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  def post_install
    geoip_data = Pathname.new "#{var}/GeoIP"
    geoip_data.mkpath

    # Since default data directory moved, copy existing DBs
    legacy_data = Pathname.new "#{HOMEBREW_PREFIX}/share/GeoIP"
    cp Dir["#{legacy_data}/*"], geoip_data if legacy_data.exist?

    full = Pathname.new "#{geoip_data}/GeoIP.dat"
    ln_s "GeoLiteCountry.dat", full unless full.exist? or full.symlink?
    full = Pathname.new "#{geoip_data}/GeoIPCity.dat"
    ln_s "GeoLiteCity.dat", full unless full.exist? or full.symlink?
  end

  test do
    system "curl", "-O", "http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz"
    system "gunzip", "GeoIP.dat.gz"
    system "#{bin}/geoiplookup", "-f", "GeoIP.dat", "8.8.8.8"
  end
end

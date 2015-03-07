class Geoip < Formula
  homepage "https://github.com/maxmind/geoip-api-c"
  url "https://github.com/maxmind/geoip-api-c/archive/v1.6.4.tar.gz"
  sha1 "f478c60e810be1ba3e4df1e4a3b839b8c604122f"

  head "https://github.com/maxmind/geoip-api-c.git"

  bottle do
    cellar :any
    sha1 "2e76cca3bd3d3e5d059a68c3bbbb418be4ec19ce" => :yosemite
    sha1 "658aa954c6abe8b7864abb21eaa081edc4e5c408" => :mavericks
    sha1 "c856d5a8237eb98627b0803ade799523e3d9be22" => :mountain_lion
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

class Geoip < Formula
  desc "GeoIP databases in a number of formats"
  homepage "https://github.com/maxmind/geoip-api-c"
  url "https://github.com/maxmind/geoip-api-c/archive/v1.6.6.tar.gz"
  sha256 "db8ed5d07292c75cb3018738e6411037f15cc2a517f38ee04c1232cbe3d30b46"

  head "https://github.com/maxmind/geoip-api-c.git"

  bottle do
    cellar :any
    sha256 "d5d86bfe8fd5956592fa475d4c8f56c56fa9c4f0e3a0d9972bce7ef1bcdaaa86" => :el_capitan
    sha256 "8394441f236c3f35fb436da2a52798aaac637818213883f074d2f976e296e11d" => :yosemite
    sha256 "ccc2707ef9e8b24747ad772cfa1949781f8e4063a90a692ad4317a699ae84526" => :mavericks
    sha256 "ad4d958f99890a460f9d8c32e7ed589d91651ce6537eed620832840c36dc699c" => :mountain_lion
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
    ln_s "GeoLiteCountry.dat", full unless full.exist? || full.symlink?
    full = Pathname.new "#{geoip_data}/GeoIPCity.dat"
    ln_s "GeoLiteCity.dat", full unless full.exist? || full.symlink?
  end

  test do
    system "curl", "-O", "http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz"
    system "gunzip", "GeoIP.dat.gz"
    system "#{bin}/geoiplookup", "-f", "GeoIP.dat", "8.8.8.8"
  end
end

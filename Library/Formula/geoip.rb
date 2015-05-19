class Geoip < Formula
  desc "GeoIP databases in a number of formats"
  homepage "https://github.com/maxmind/geoip-api-c"
  url "https://github.com/maxmind/geoip-api-c/archive/v1.6.5.tar.gz"
  sha1 "55950b436718a32ff9f8c9cfb36cec0aa3674253"

  head "https://github.com/maxmind/geoip-api-c.git"

  bottle do
    cellar :any
    sha256 "eedb986a2e5daf59d9f7982455773de7f3bc5be6948911a8e5667b6598e37e38" => :yosemite
    sha256 "619929de31b302b9423465399c1954f9071aacd0c0f02d1c86760a7918e868b5" => :mavericks
    sha256 "a8c5a78c7bb3587e9f84c7474aa85e1f2a4b6b2bcdb9b5de103ef2e7472acfa2" => :mountain_lion
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

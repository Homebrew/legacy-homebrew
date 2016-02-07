class Geoip < Formula
  desc "This library is for the GeoIP Legacy format (dat)"
  homepage "https://github.com/maxmind/geoip-api-c"
  url "https://github.com/maxmind/geoip-api-c/releases/download/v1.6.9/GeoIP-1.6.9.tar.gz"
  sha256 "4b446491843de67c1af9b887da17a3e5939e0aeed4826923a5f4bf09d845096f"

  head "https://github.com/maxmind/geoip-api-c.git"

  bottle do
    cellar :any
    sha256 "dc7c79eef8500456198b3ba981c13498c049b2f8c4398fe885534c386dfbf283" => :el_capitan
    sha256 "0525ae799027334cafb551a349c7837c8b17853660797dff430b035ca0eedc65" => :yosemite
    sha256 "5ee66187d1b4510fd463ebb8bf360c2d78a4252467a0e10e905a2a3502f9bcaa" => :mavericks
  end

  option :universal

  depends_on "geoipupdate" => :optional

  def install
    ENV.universal_binary if build.universal?

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

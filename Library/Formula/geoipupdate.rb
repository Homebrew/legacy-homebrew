require 'formula'

class Geoipupdate < Formula
  homepage 'https://github.com/maxmind/geoipupdate'
  url 'https://github.com/maxmind/geoipupdate/releases/download/v2.0.0/geoipupdate-2.0.0.tar.gz'
  sha1 'd3c90ad9c9ad5974e8a5a30c504e7827978ddea7'

  head do
    url 'https://github.com/maxmind/geoipupdate.git'
  end

  # Because the patch requires regenerating the configure script;
  # move these back to the head spec on next release
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  option :universal

  # Fixes use of getline on pre-Lion; will be in next release
  def patches
    unless build.head?
      "https://github.com/maxmind/geoipupdate/commit/bdf11969f4c7c6b173466092287a2fdbd485b248.patch"
    end
  end

  def install
    ENV.universal_binary if build.universal?

    # Download free databases by default
    # See https://github.com/maxmind/geoip-api-c#150
    inreplace 'conf/GeoIP.conf.default', 'YOUR_USER_ID_HERE', '999999'
    inreplace 'conf/GeoIP.conf.default', 'YOUR_LICENSE_KEY_HERE', '000000000000'
    inreplace 'conf/GeoIP.conf.default', /^ProductIds .*$/, 'ProductIds 506 533'

    system "./bootstrap"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--datadir=#{var}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/geoipupdate", "-v"
  end
end

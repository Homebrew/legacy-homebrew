require 'formula'

class Geoipupdate < Formula
  homepage 'https://github.com/maxmind/geoipupdate'

  stable do
    url "https://github.com/maxmind/geoipupdate/releases/download/v2.0.0/geoipupdate-2.0.0.tar.gz"
    sha1 "d3c90ad9c9ad5974e8a5a30c504e7827978ddea7"

    # Fixes use of getline on pre-Lion; will be in next release
    patch do
      url "https://github.com/maxmind/geoipupdate/commit/bdf11969f4c7c6b173466092287a2fdbd485b248.diff"
      sha1 "80a8dd08ccbcd1c1d73c1bff6b5ce62adc254b96"
    end
  end

  head 'https://github.com/maxmind/geoipupdate.git'

  # Because the patch requires regenerating the configure script;
  # move these back to the head spec on next release
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  option :universal

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

  def post_install
    (var/"GeoIP").mkpath
  end

  test do
    system "#{bin}/geoipupdate", "-v"
  end
end

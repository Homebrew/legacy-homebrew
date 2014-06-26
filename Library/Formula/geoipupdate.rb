require 'formula'

class Geoipupdate < Formula
  homepage 'https://github.com/maxmind/geoipupdate'

  stable do
    url "https://github.com/maxmind/geoipupdate/releases/download/v2.0.1/geoipupdate-2.0.1.tar.gz"
    sha1 "11048de992e21bc99b22caa781ae27625e6a62dc"
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

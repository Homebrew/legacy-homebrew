require 'formula'

class Geoip < Formula
  homepage 'http://www.maxmind.com/app/c'
  url 'http://geolite.maxmind.com/download/geoip/api/c/GeoIP-1.4.8.tar.gz'
  sha1 '7bafb9918e3c35a6ccc71bb14945245d45c4b796'

  # These are needed for the autoreconf it always tries to run.
  depends_on :automake
  depends_on :libtool

  option :universal

  def install
    ENV.universal_binary if build.universal?

    # Fixes a build error on Lion when configure does a variant of autoreconf
    # that results in a botched Makefile, causing this error:
    # No rule to make target '../libGeoIP/libGeoIP.la', needed by 'geoiplookup'
    # This works on Snow Leopard also when it tries but fails to run autoreconf.
    system "autoreconf", "-ivf"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

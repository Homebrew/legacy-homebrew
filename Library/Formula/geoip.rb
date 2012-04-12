require 'formula'

class Geoip < Formula
  url 'http://geolite.maxmind.com/download/geoip/api/c/GeoIP-1.4.8.tar.gz'
  homepage 'http://www.maxmind.com/app/c'
  md5 '05b7300435336231b556df5ab36f326d'

  # These are needed for the autoreconf it always tries to run.
  if MacOS.xcode_version.to_f >= 4.3
    depends_on 'automake' => :build
    depends_on 'libtool' => :build
  end

  def options
    [["--universal", "Build a universal binary."]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?

    # Fixes a build error on Lion when configure does a variant of autoreconf
    # that results in a botched Makefile, causing this error:
    # No rule to make target '../libGeoIP/libGeoIP.la', needed by 'geoiplookup'
    # This works on Snow Leopard also when it tries but fails to run autoreconf.
    system "autoreconf", "-ivf"

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end

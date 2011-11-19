require 'formula'

class Geoip < Formula
  url 'http://geolite.maxmind.com/download/geoip/api/c/GeoIP-1.4.8.tar.gz'
  homepage 'http://www.maxmind.com/app/c'
  md5 '05b7300435336231b556df5ab36f326d'

  def options
    [["--universal", "Build a universal binary."]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end

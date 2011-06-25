require 'formula'

class Geoip < Formula
  url 'http://geolite.maxmind.com/download/geoip/api/c/GeoIP-1.4.7.tar.gz'
  homepage 'http://www.maxmind.com/app/c'
  md5 'a802175d5b7e2b57b540a7dd308d9205'

  def options
    [["--universal", "Build a universal binary."]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end

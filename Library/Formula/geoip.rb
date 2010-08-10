require 'formula'

class Geoip <Formula
  url 'http://geolite.maxmind.com/download/geoip/api/c/GeoIP-1.4.6.tar.gz'
  homepage 'http://www.maxmind.com/app/c'
  md5 'cb14b1beeb40631a12676b11ca0c309a'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end

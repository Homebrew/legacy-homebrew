require 'formula'

# install Ruby API for Maxmind GeoIP C library
#
# (alternative to MacPorts rb-net-geoip)

class NetGeoip < Formula
  depends_on 'geoip'

  url 'http://geolite.maxmind.com/download/geoip/api/ruby/net-geoip-0.07.tar.gz'
  homepage 'http://www.maxmind.com/app/ruby'
  md5 '7cdc43b9382af14ddf4dd1295f4a402c'

  def install
    system "ruby extconf.rb"
    system "make"
    system "make install"
  end

  def test
    require 'net-geoip'
  end
end

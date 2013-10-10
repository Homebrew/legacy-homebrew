require 'formula'

class Goaccess < Formula
  homepage 'http://goaccess.prosoftcorp.com/'
  url 'http://downloads.sourceforge.net/project/goaccess/0.6.1/goaccess-0.6.1.tar.gz'
  sha1 '9604087ca730c288b461a260ab50bf7dd38ca281'

  head 'https://github.com/allinurl/goaccess.git'

  option 'enable-geoip', "Enable IP location information using GeoIP"

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'geoip' if build.include? "enable-geoip"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--enable-geoip" if build.include? "enable-geoip"

    system "./configure", *args
    system "make install"
  end
end

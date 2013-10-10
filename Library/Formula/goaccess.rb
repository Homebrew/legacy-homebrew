require 'formula'

class Goaccess < Formula
  homepage 'http://goaccess.prosoftcorp.com/'
  url 'http://downloads.sourceforge.net/project/goaccess/0.6.1/goaccess-0.6.1.tar.gz'
  sha1 '9604087ca730c288b461a260ab50bf7dd38ca281'

  head 'https://github.com/allinurl/goaccess.git'

  option 'enable-geoip', "Enable IP location information using GeoIP"
  # option 'enable-utf8', "UTF-8 support for wide characters using ncurses"

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'geoip' if build.include? "enable-geoip"
  # depends_on 'ncurses' if build.include? "enable-utf8"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--enable-geoip" if build.include? "enable-geoip"
    # args << "--enable-utf8" if build.include? "enable-utf8"

    system "./configure", *args
    system "make install"
  end
end

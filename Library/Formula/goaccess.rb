require 'formula'

class Goaccess < Formula
  homepage 'http://goaccess.prosoftcorp.com/'
  url 'http://tar.goaccess.io/goaccess-0.8.tar.gz'
  sha1 '8c220e7e65a6e45ae5a2221e241e976d07c23def'

  option 'enable-geoip', "Enable IP location information using GeoIP"

  head do
    url "https://github.com/allinurl/goaccess.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'geoip' if build.include? "enable-geoip"

  def install
    system "autoreconf", "-vfi" if build.head?
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

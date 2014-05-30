require 'formula'

class Goaccess < Formula
  homepage 'http://goaccess.prosoftcorp.com/'
  url 'https://downloads.sourceforge.net/project/goaccess/0.7.1/goaccess-0.7.1.tar.gz'
  sha1 '3b546062776df00bd539072c5bdfec2a62cbeb84'

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

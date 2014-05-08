require 'formula'

class Goaccess < Formula
  homepage 'http://goaccess.prosoftcorp.com/'
  url 'https://downloads.sourceforge.net/project/goaccess/0.7/goaccess-0.7.tar.gz'
  sha1 '1a887dc7182c91726137aaf6a4627efdd82d988e'

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

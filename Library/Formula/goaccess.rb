require "formula"

class Goaccess < Formula
  homepage "http://goaccess.prosoftcorp.com/"
  url "http://tar.goaccess.io/goaccess-0.8.1.tar.gz"
  sha1 "f9e7f277e46af3c97d0f133d7a44031db0c3e531"

  bottle do
    sha1 "081452df0eca44ca9d59591985956090087654e8" => :mavericks
    sha1 "a74a803534ae1050fea03429b11bb298909ab218" => :mountain_lion
    sha1 "3a327d75218841c39c356f7c03c8a03212920314" => :lion
  end

  option "enable-geoip", "Enable IP location information using GeoIP"

  head do
    url "https://github.com/allinurl/goaccess.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "geoip" if build.include? "enable-geoip"

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

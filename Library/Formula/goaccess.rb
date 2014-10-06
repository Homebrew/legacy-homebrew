require "formula"

class Goaccess < Formula
  homepage "http://goaccess.prosoftcorp.com/"
  url "http://tar.goaccess.io/goaccess-0.8.5.tar.gz"
  sha1 "a69e629682b11b5413af9112f386ef8bf9182346"

  bottle do
    sha1 "97e5b8257e79910a253ec972cb9535f02caec511" => :mavericks
    sha1 "0a17b2ba03ec8575eb3deba610fa200aeb052b92" => :mountain_lion
    sha1 "98e9188ea8aa24f8e51dd046d6003b81c894f53e" => :lion
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

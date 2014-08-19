require "formula"

class Goaccess < Formula
  homepage "http://goaccess.prosoftcorp.com/"
  url "http://tar.goaccess.io/goaccess-0.8.3.tar.gz"
  sha1 "e5ed8a3d6ba2c5b338b5e3e22da8024e7c58ded3"

  bottle do
    sha1 "fa8fb53207de715e9b5898b47d8f0ab536ce3b6d" => :mavericks
    sha1 "54bb6d73d9e97b678ac8aa9efef411189689054b" => :mountain_lion
    sha1 "53b5930276abb6f3f2d4bf1bf9f79742dad0cd3d" => :lion
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

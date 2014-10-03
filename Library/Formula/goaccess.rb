require "formula"

class Goaccess < Formula
  homepage "http://goaccess.prosoftcorp.com/"
  url "http://tar.goaccess.io/goaccess-0.8.5.tar.gz"
  sha1 "a69e629682b11b5413af9112f386ef8bf9182346"

  bottle do
    sha1 "9c5adcd9d96d92881c2aedecf13e1d42a4d829af" => :mavericks
    sha1 "380c3c8298fb6c9e77297c708360d0abfc097650" => :mountain_lion
    sha1 "0e9a7dfd63e7565fddd54a6b7fff13f1e8a81c46" => :lion
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

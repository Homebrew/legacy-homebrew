require "formula"

class Goaccess < Formula
  homepage "http://goaccess.prosoftcorp.com/"
  url "http://tar.goaccess.io/goaccess-0.9.tar.gz"
  sha1 "fd18df44e09d4fac4ea90f1552e8ff9da0d6633c"

  bottle do
    sha256 "d768a98f42f9ec841328c859d6505e80904ec3c28e3bba38532ee67425d994d5" => :yosemite
    sha256 "215ca9e4613a4ee206c17b3ec13bb46f610830102fdd3ac49c2c5c4f5f48ce3a" => :mavericks
    sha256 "f1de0dde3a407eb515de8ca4faa40720e2f3c735cc8e3c9fec1f0d9bcecfbf31" => :mountain_lion
  end

  option "with-geoip", "Enable IP location information using GeoIP"
  deprecated_option "enable-geoip" => "with-geoip"

  head do
    url "https://github.com/allinurl/goaccess.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "geoip" => :optional

  def install
    system "autoreconf", "-vfi" if build.head?
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--enable-geoip" if build.with? "geoip"

    system "./configure", *args
    system "make install"
  end
end

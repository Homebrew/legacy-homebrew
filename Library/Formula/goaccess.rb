class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "http://goaccess.io/"
  url "http://tar.goaccess.io/goaccess-0.9.3.tar.gz"
  sha256 "aa5819d47d4d554d13b5d4d79524b907ade685accf8c89d399fba0e2a318bc46"

  bottle do
    sha256 "ca6fd910536691b5325cda7a217006b81f90ffd1a330c0d9aa798a674512de43" => :yosemite
    sha256 "e6dfced095f25cb96beb0382508ee545073bd7ffc32606471152f32949b429c9" => :mavericks
    sha256 "bcf46327a8aeb5df14590687da6572ffe529e32dbfc5c2c64b470ba9e6b3143b" => :mountain_lion
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
    system "make", "install"
  end
end

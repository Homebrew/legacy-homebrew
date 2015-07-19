class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "http://goaccess.io/"
  url "http://tar.goaccess.io/goaccess-0.9.2.tar.gz"
  sha256 "b6ee0742f7ecc657633d680bd6cb3497b93b4be2f880ad68e3f48a72d81b2cd0"

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

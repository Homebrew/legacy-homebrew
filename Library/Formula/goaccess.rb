class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "http://goaccess.prosoftcorp.com/"
  url "http://tar.goaccess.io/goaccess-0.9.2.tar.gz"
  sha256 "b6ee0742f7ecc657633d680bd6cb3497b93b4be2f880ad68e3f48a72d81b2cd0"

  bottle do
    sha256 "0bd28778ccb4d3976313ec429f62ec67528aa2db33db32023569fdf2ee5cc065" => :yosemite
    sha256 "912546461e75e75e3cb44a88715a267b4de82cc4e4573f8a559e9e375680ccde" => :mavericks
    sha256 "58d9cabba37d663a94e8b1ece0ee794dc9717f918199577a5b422b116557266b" => :mountain_lion
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

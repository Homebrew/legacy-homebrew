class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "http://goaccess.io/"
  url "http://tar.goaccess.io/goaccess-0.9.3.tar.gz"
  sha256 "aa5819d47d4d554d13b5d4d79524b907ade685accf8c89d399fba0e2a318bc46"

  bottle do
    sha256 "a8f198a65bbc1f78374f4875de7ae292bc4c6468eafc30e1548733cc3c8d4d72" => :yosemite
    sha256 "c3b9794ea9b90361e81630e9550a3ac6d7a3e413e5c61d7dc00fd3f942b1c802" => :mavericks
    sha256 "c4da90f9f07798cc89c94eb158b878a30609f05f8be00b38454256bbe2203b0a" => :mountain_lion
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

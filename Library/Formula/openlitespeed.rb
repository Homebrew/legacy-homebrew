class Openlitespeed < Formula
  desc "High-performance, lightweight HTTP server"
  homepage "http://open.litespeedtech.com/mediawiki/"
  url "http://open.litespeedtech.com/packages/openlitespeed-1.3.10.tgz"
  sha1 "4a409b65cacc3ee5e2855ab213a5f3e9858a8003"
  head "https://github.com/litespeedtech/openlitespeed.git"

  option "with-debug", "Compile with support for debug log"
  option "with-spdy", "Compile with support for SPDY module"

  depends_on "pcre"
  depends_on "geoip"
  depends_on "openssl"

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--enable-debug" if build.with? "debug"
    args << "--enable-spdy" if build.with? "spdy"
    args << "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "./configure", *args
    system "make", "install"
  end
end

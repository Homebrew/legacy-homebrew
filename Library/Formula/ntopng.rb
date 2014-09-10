require "formula"

class Ntopng < Formula
  homepage "http://www.ntop.org/products/ntop/"
  url "https://downloads.sourceforge.net/project/ntop/ntopng/ntopng-1.2.1.tgz"
  sha1 "e90a8cc045fb4d65d57d029908a9b029d801490c"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "json-glib" => :build
  depends_on "json-c"
  depends_on "wget" => :build
  depends_on "rrdtool"
  depends_on "zeromq" => :build
  depends_on "luajit" => :build
  depends_on "gnutls" => :build
  depends_on "geoip"
  depends_on "redis"

  def install
    system "./autogen.sh"
    system "./configure","--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ntopng", "-h"
  end
end

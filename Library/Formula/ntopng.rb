require "formula"

class Ntopng < Formula
  homepage "http://www.ntop.org/products/ntop/"
  url "https://downloads.sourceforge.net/project/ntop/ntopng/ntopng-1.2.0_r8116.tgz"
  sha1 "81189e53aa71084caf11b5462fb752363988fa01"
  version "1.2.0"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "json-glib" => :build
  depends_on "json-c" => :build
  depends_on "wget" => :build
  depends_on "rrdtool" => :build
  depends_on "zeromq" => :build
  depends_on "luajit" => :build
  depends_on "gnutls"
  depends_on "geoip" => :build
  depends_on "sqlite" => :build
  depends_on "redis"

  def install
    system "./autogen.sh"
    system "./configure","--prefix=#{prefix}"
    system "make"
    system "make","install"
  end

  test do
    system "#{bin}/ntopng","--version"
  end

end

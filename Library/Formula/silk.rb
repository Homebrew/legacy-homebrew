require "formula"

class Silk < Formula
  homepage "http://tools.netsa.cert.org/silk/"
  url "http://tools.netsa.cert.org/releases/silk-3.8.2.tar.gz"
  sha1 "090972127175272c1cc82d6e419a65c8ecfbd275"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "yaf"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-ipv6",
                          "--enable-data-rootdir=#{var}/silk"
    system "make"
    system "make install"

    (var+"silk").mkpath
  end
end

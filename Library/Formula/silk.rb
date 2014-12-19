require "formula"

class Silk < Formula
  homepage "http://tools.netsa.cert.org/silk/"
  url "http://tools.netsa.cert.org/releases/silk-3.9.0.tar.gz"
  sha1 "40dd51401f8688cf5e9a9b0146e1a9e0ccb654aa"

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

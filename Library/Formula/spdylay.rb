require "formula"

class Spdylay < Formula
  homepage "https://github.com/tatsuhiro-t/spdylay"
  url "https://github.com/tatsuhiro-t/spdylay/archive/v1.2.5.tar.gz"
  sha1 "77bf1f28ebbaf388886831bbf409ab8011ab0886"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent" => :recommended
  depends_on "libxml2"
  depends_on "openssl"

  def install
    system "autoreconf -i"
    system "automake"
    system "autoconf"

    ENV["ZLIB_CFLAGS"] = "-I/usr/include"
    ENV["ZLIB_LIBS"] = "-L/usr/lib -lz"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/spdycat", "-ns", "https://www.google.com"
  end
end

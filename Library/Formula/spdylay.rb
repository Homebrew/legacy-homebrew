require "formula"

class Spdylay < Formula
  homepage "https://github.com/tatsuhiro-t/spdylay"
  url "https://github.com/tatsuhiro-t/spdylay/archive/v1.2.4.tar.gz"
  sha1 "5bf481fa4859029806d886a31e85b999aee3a3f0"

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

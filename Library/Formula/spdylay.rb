require "formula"

class Spdylay < Formula
  homepage "https://github.com/tatsuhiro-t/spdylay"
  url "https://github.com/tatsuhiro-t/spdylay/archive/v1.3.1.tar.gz"
  sha1 "2cb544364a1797d2abf46a08da95044c1c51aa74"

  bottle do
    cellar :any
    sha1 "6a0b34fbd6d032b40e05392254a9427b64afb7d7" => :mavericks
    sha1 "d0f350a74c629d3e657277bffb7b865dcebd2bbb" => :mountain_lion
    sha1 "157a4de06a02a54eb8c4851d33c2d1b8f72d9424" => :lion
  end

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
    system "make", "install"
  end

  test do
    system "#{bin}/spdycat", "-ns", "https://www.google.com"
  end
end

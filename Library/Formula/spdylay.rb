require "formula"

class Spdylay < Formula
  homepage "https://github.com/tatsuhiro-t/spdylay"
  url "https://github.com/tatsuhiro-t/spdylay/archive/v1.3.1.tar.gz"
  sha1 "2cb544364a1797d2abf46a08da95044c1c51aa74"

  bottle do
    cellar :any
    sha1 "63f45497fc6e3e79a999547f495398582557e2b2" => :mavericks
    sha1 "29c05f3b61dcbdb431906fe76e5cbcbd2f974a4b" => :mountain_lion
    sha1 "371fb03493809b2de2c0778a4ca2c5a319d7d1ef" => :lion
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

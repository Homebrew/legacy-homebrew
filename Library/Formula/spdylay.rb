require "formula"

class Spdylay < Formula
  homepage "https://github.com/tatsuhiro-t/spdylay"
  url "https://github.com/tatsuhiro-t/spdylay/archive/v1.2.5.tar.gz"
  sha1 "77bf1f28ebbaf388886831bbf409ab8011ab0886"
  revision 1

  bottle do
    cellar :any
    sha1 "cc83129be8229d47e618aed02f20406296c76a86" => :mavericks
    sha1 "63cbd6dab3b8cf7a1ef9b801853ef46eb67c1bea" => :mountain_lion
    sha1 "399903427dc0c5e7f7303fd14872020ba633e4ca" => :lion
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

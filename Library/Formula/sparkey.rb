require "formula"

class Sparkey < Formula
  homepage "https://github.com/spotify/sparkey/"
  url "https://github.com/spotify/sparkey/archive/sparkey-0.2.0.tar.gz"
  sha1 "1b7dca2410dffb55d96b8e6eef384830b7d96553"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "snappy" => :build

  def install
    system "autoreconf", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "sparkey createlog -c snappy test.spl"
    system "echo foo.bar | sparkey appendlog -d . test.spl"
    system "sparkey writehash test.spl"
    system "sparkey get test.spi foo | grep ^bar$"
  end
end

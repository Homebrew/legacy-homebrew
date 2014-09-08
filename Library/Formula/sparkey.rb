require "formula"

class Sparkey < Formula
  homepage "https://github.com/spotify/sparkey/"
  url "https://github.com/spotify/sparkey/archive/sparkey-0.2.0.tar.gz"
  sha1 "1b7dca2410dffb55d96b8e6eef384830b7d96553"

  bottle do
    cellar :any
    sha1 "5dfa39af0fe70769f77637c7fdbfffd67f273621" => :mavericks
    sha1 "49276b9522232bdcfef1d0b4f43fb3c314b1a98d" => :mountain_lion
    sha1 "6ae3cff3918cd0f4fbdcecc830a89118eaf4e453" => :lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "snappy"

  def install
    system "autoreconf", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/sparkey createlog -c snappy test.spl"
    system "echo foo.bar | #{bin}/sparkey appendlog -d . test.spl"
    system "#{bin}/sparkey writehash test.spl"
    system "#{bin}/sparkey get test.spi foo | grep ^bar$"
  end
end

require "formula"

class Mozjpeg < Formula
  homepage "https://github.com/mozilla/mozjpeg"
  url "https://github.com/mozilla/mozjpeg/archive/v1.0.1.tar.gz"
  sha1 "daa28d6396a66d04b92fad223b763dd306d68bd9"

  head "https://github.com/mozilla/mozjpeg.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "jpeg"

  keg_only "mozjpeg is not linked to prevent conflicts with the standard libjpeg."

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--with-jpeg8"
    system "make", "install"
  end
end

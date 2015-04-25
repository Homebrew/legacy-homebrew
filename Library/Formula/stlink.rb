require "formula"

class Stlink < Formula
  homepage "https://github.com/texane/stlink"
  url "https://github.com/texane/stlink/archive/1.1.0.tar.gz"
  sha256 "3ac4dfcf1da0da40a1b71a8789ff0f1e7d978ea0222158bebd2de916c550682c"

  bottle do
    cellar :any
    sha1 "6c0fa936a2fbf20fb05c2a9503cbd8b7b3b6a8d6" => :yosemite
    sha1 "3aa833eca3455df534e2b1f484543f9e5e09f1ac" => :mavericks
    sha1 "9516c50fc08774b01d8893b8fc0cd5d11ebae017" => :mountain_lion
  end

  depends_on "libusb"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "st-util", "-h"
  end
end

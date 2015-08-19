class Stlink < Formula
  desc "stm32 discovery line Linux programmer"
  homepage "https://github.com/texane/stlink"
  url "https://github.com/texane/stlink/archive/1.1.0.tar.gz"
  sha256 "3ac4dfcf1da0da40a1b71a8789ff0f1e7d978ea0222158bebd2de916c550682c"

  bottle do
    cellar :any
    sha256 "915897898e90e285a22526f3a0f34f39e21e089c01bb1b36d462620b50852a59" => :yosemite
    sha256 "33e1c9519502439c02f2bbada029053269e0574d4351482e9729c9a30b5446d1" => :mavericks
    sha256 "1d062d03fa7290e2047d78b6f2b710989fca9c4f7f1a701d65468d7c115aa9ef" => :mountain_lion
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

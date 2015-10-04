class Stlink < Formula
  desc "stm32 discovery line Linux programmer"
  homepage "https://github.com/texane/stlink"
  url "https://github.com/texane/stlink/archive/1.1.0.tar.gz"
  sha256 "3ac4dfcf1da0da40a1b71a8789ff0f1e7d978ea0222158bebd2de916c550682c"

  head "https://github.com/texane/stlink.git"

  bottle do
    cellar :any
    revision 1
    sha256 "ab03c755109f6fb00dc5ba0b667c91b1b06887098b5e7ca9b4ff95407f7e6dfd" => :el_capitan
    sha256 "68217df89dd719dc8345ec065f16a5c48a909fb1dbe4f6d638707110e6526e3f" => :yosemite
    sha256 "36ad00988ff74f08da8be3653ed7070b206ac53c9720e5c6e2a5476b2d1fa7cf" => :mavericks
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
    system bin/"st-util", "-h"
  end
end

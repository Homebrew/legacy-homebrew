require "formula"

class Lensfun < Formula
  homepage "http://lensfun.sourceforge.net/"
  head "git://git.code.sf.net/p/lensfun/code"
  url "https://downloads.sourceforge.net/project/lensfun/0.3.0/lensfun-0.3.0.tar.bz2"
  sha1 "60e2bf3a6a2f495076db1d88778a00d358cf0b69"

  bottle do
    sha1 "3d14bc917c95bda7eb6f9e98f83c18b22fb048f1" => :yosemite
    sha1 "f75c7915e5701e605275e6d48a8c5c12ec981948" => :mavericks
    sha1 "b6b0966f02558cb8304a1206536a1d1e16afcb05" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "gettext"
  depends_on "libpng"
  depends_on "doxygen" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end

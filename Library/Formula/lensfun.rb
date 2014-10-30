require "formula"

class Lensfun < Formula
  homepage "http://lensfun.sourceforge.net/"
  head "git://git.code.sf.net/p/lensfun/code"
  url "https://downloads.sourceforge.net/project/lensfun/0.3.0/lensfun-0.3.0.tar.bz2"
  sha1 "60e2bf3a6a2f495076db1d88778a00d358cf0b69"

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

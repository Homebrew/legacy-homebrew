require "formula"

class Arpon < Formula
  homepage "http://arpon.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arpon/arpon/ArpON-2.7.2.tar.gz"
  sha1 "75e4b1f2a2c18e4982fc5797547d52a13194f81d"

  head "git://git.code.sf.net/p/arpon/code"

  depends_on "cmake" => :build
  depends_on "libdnet"
  depends_on "libnet"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end

require "formula"

class Gl2ps < Formula
  homepage "http://www.geuz.org/gl2ps/"
  url "http://geuz.org/gl2ps/src/gl2ps-1.3.8.tgz"
  sha1 "792e11db0fe7a30a4dc4491af5098b047ec378b1"
  revision 1

  depends_on "cmake" => :build
  depends_on "libpng"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end

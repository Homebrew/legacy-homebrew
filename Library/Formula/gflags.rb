require 'formula'

class Gflags < Formula
  homepage "http://code.google.com/p/google-gflags/"
  url "https://github.com/schuhschuh/gflags/archive/v2.1.1.tar.gz"
  sha1 "59b37548b10daeaa87a3093a11d13c2442ac6849"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end

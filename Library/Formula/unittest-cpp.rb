require 'formula'

class UnittestCpp < Formula
  homepage 'http://unittest-cpp.sourceforge.net/'
  head "https://github.com/unittest-cpp/unittest-cpp.git"

  depends_on "cmake" => :build
  def install
      system "cmake", ".", *std_cmake_args
      system "make", "install"
  end
end

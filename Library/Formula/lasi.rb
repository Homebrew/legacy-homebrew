require "formula"

class Lasi < Formula
  homepage "http://www.unifont.org/lasi/"
  url "https://downloads.sourceforge.net/project/lasi/lasi/1.1.2%20Source/libLASi-1.1.2.tar.gz"
  sha1 "5f1764273c71cc196c095998da8110ca4ad620ae"

  head "https://lasi.svn.sourceforge.net/svnroot/lasi/trunk"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "pango"

  def install
    # None is valid, but lasi's CMakeFiles doesn't think so for some reason
    args = std_cmake_args - %w{-DCMAKE_BUILD_TYPE=None}

    system "cmake", ".", "-DCMAKE_BUILD_TYPE=Release", *args
    system "make install"
  end
end

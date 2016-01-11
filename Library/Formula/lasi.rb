class Lasi < Formula
  desc "C++ stream output interface for creating Postscript documents"
  homepage "http://www.unifont.org/lasi/"
  url "https://downloads.sourceforge.net/project/lasi/lasi/1.1.2%20Source/libLASi-1.1.2.tar.gz"
  sha256 "448c6e52263a1e88ac2a157f775c393aa8b6cd3f17d81fc51e718f18fdff5121"

  head "https://lasi.svn.sourceforge.net/svnroot/lasi/trunk"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "pango"

  def install
    # None is valid, but lasi's CMakeFiles doesn't think so for some reason
    args = std_cmake_args - %w[-DCMAKE_BUILD_TYPE=None]

    system "cmake", ".", "-DCMAKE_BUILD_TYPE=Release", *args
    system "make", "install"
  end
end

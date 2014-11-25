require "formula"

class Assimp < Formula
  homepage "http://assimp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/assimp/assimp-3.1/assimp-3.1.1_no_test_models.zip"
  sha1 "d7bc1d12b01d5c7908d85ec9ff6b2d972e565e2d"
  version "3.1.1"

  head "https://github.com/assimp/assimp.git"

  bottle do
    cellar :any
    sha1 "0b103054733c3791ad92cdb51b0acd7e053baf61" => :yosemite
    sha1 "a34746e16ce3ec4d5737db73db1ddd766d688619" => :mavericks
    sha1 "7a0bb7602c85f83cb775a95bfe384bf8a5ca4283" => :mountain_lion
  end

  option "without-boost", "Compile without thread safe logging or multithreaded computation if boost isn't installed"

  depends_on "cmake" => :build
  depends_on "boost" => [:recommended, :build]

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # Library test.
    (testpath/'test.cpp').write <<-EOS.undent
      #include <assimp/Importer.hpp>
      int main() {
        Assimp::Importer importer;
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-lassimp", "-o", "test"
    system "./test"

    # Application test.
    (testpath/"test.obj").write <<-EOS.undent
      # WaveFront .obj file - a single square based pyramid

      # Start a new group:
      g MySquareBasedPyramid

      # List of vertices:
      v -0.5 0 0.5    # Front left.
      v 0.5 0 0.5   # Front right.
      v 0.5 0 -0.5    # Back right
      v -0.5 0 -0.5   # Back left.
      v 0 1 0           # Top point (top of pyramid).

      # List of faces:
      f 4 3 2 1       # Square base (note: normals are placed anti-clockwise).
      f 1 2 5         # Triangle on front.
      f 3 4 5         # Triangle on back.
      f 4 1 5         # Triangle on left side.
      f 2 3 5
    EOS
    system "assimp", "export", testpath/"test.obj", testpath/"test.ply"
  end
end

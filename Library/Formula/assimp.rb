class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "http://assimp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/assimp/assimp-3.1/assimp-3.1.1_no_test_models.zip"
  sha256 "da9827876f10a8b447270368753392cfd502e70a2e9d1361554e5dfcb1fede9e"
  version "3.1.1"

  head "https://github.com/assimp/assimp.git"

  bottle do
    cellar :any
    revision 1
    sha1 "147bc1b92a31526950262c123b2d78d78b092005" => :yosemite
    sha1 "a44ef2d43ab074beb0b03196e65df3bf1a8e406b" => :mavericks
    sha1 "31bb541f50c5ff22055ce2f608ae88ab4997407c" => :mountain_lion
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
    (testpath/"test.cpp").write <<-EOS.undent
      #include <assimp/Importer.hpp>
      int main() {
        Assimp::Importer importer;
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lassimp", "-o", "test"
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

class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "http://assimp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/assimp/assimp-3.1/assimp-3.1.1_no_test_models.zip"
  version "3.1.1"
  sha256 "da9827876f10a8b447270368753392cfd502e70a2e9d1361554e5dfcb1fede9e"

  head "https://github.com/assimp/assimp.git"

  bottle do
    cellar :any
    revision 2
    sha256 "368ba868e7715635a06d8d677d61f48249df892cf34b9ca71401d91e39e5ac19" => :el_capitan
    sha256 "8b60177099c612ae291c0509900bb73ec6bfeb5024ac3927e3902e31ed7edc25" => :yosemite
    sha256 "a4d31ecdae6b3b7bf8c8d8db35d2406e53f9fca8896fcae1efc706f94e3049f0" => :mavericks
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

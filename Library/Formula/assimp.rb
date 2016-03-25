class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "http://www.assimp.org"
  url "https://github.com/assimp/assimp/archive/v3.2.tar.gz"
  sha256 "187f825c563e84b1b17527a4da0351aa3d575dfd696a9d204ae4bb19ee7df94a"

  head "https://github.com/assimp/assimp.git"

  bottle do
    cellar :any
    sha256 "b3d78e827c13d6f66a98bd9c52cf2a3bd44a69082f33183f2afbcbbf4fe68fc5" => :el_capitan
    sha256 "bf4f61f6fe5c3debd29c768bba9024ca1ce51606fe2e9814ad36415ea4f391a7" => :yosemite
    sha256 "82faa217aabc364693ca749e55f990cf16c8cc808eceb768d0880f70cff95d59" => :mavericks
  end

  option "without-boost", "Compile without thread safe logging or multithreaded computation if boost isn't installed"

  depends_on "cmake" => :build
  depends_on "boost" => [:recommended, :build]

  def install
    args = std_cmake_args
    args << "-DASSIMP_BUILD_TESTS=OFF"
    system "cmake", *args
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

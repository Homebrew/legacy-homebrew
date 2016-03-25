class Chipmunk < Formula
  desc "2D rigid body physics library written in C"
  homepage "https://chipmunk-physics.net/"
  url "https://chipmunk-physics.net/release/Chipmunk-7.x/Chipmunk-7.0.1.tgz"
  sha256 "fe54b464777d89882a9f9d3d6deb17189af8bc5d63833b25bb1a7d16c3e69260"

  head "https://github.com/slembcke/Chipmunk2D.git"

  bottle do
    cellar :any
    sha256 "b102e80b437f3547447919f633e0e247afe5644d545271439a0172777527a442" => :el_capitan
    sha256 "778a6264346121cce1a36f6cb77c3ee3b4dfea44cb95f381f46b61ba04aa2080" => :yosemite
    sha256 "638b8122b0ad67cdb134839805e82cd702e9ba4a787b6fbb8b71ff0161a47700" => :mavericks
    sha256 "694a4ec57d96393397a18f9df95fc272900a1602bd962fcbb45e4e7fc23e16a1" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_DEMOS=OFF", *std_cmake_args
    system "make", "install"

    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <chipmunk.h>

      int main(void){
        cpVect gravity = cpv(0, -100);
        cpSpace *space = cpSpaceNew();
        cpSpaceSetGravity(space, gravity);

        cpSpaceFree(space);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/chipmunk", "-L#{lib}", "-lchipmunk",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end

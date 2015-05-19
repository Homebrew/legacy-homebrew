class Chipmunk < Formula
  desc "2D rigid body physics library written in C"
  homepage "http://chipmunk-physics.net/"
  url "http://chipmunk-physics.net/release/Chipmunk-7.x/Chipmunk-7.0.0.tgz"
  sha256 "14ab380396a96b15951c42a2d7ca259a53ecab4e550a71857d13dcfd388a51cd"

  head "https://github.com/slembcke/Chipmunk2D.git"

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

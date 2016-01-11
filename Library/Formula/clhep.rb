class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.3.1.1.tgz"
  sha256 "0e2b170df99176feb0aa4f20ea3b33463193c086682749790c5b9b79388d0ff4"

  bottle do
    cellar :any
    sha256 "2201b22072c449346bea78bbad4f46fccd968b11b342c83310c25e79c16f0997" => :el_capitan
    sha256 "18e6581c3d9d83e9853283c4d00e021701135b502432bab291c8e4a7e8e9e6db" => :yosemite
    sha256 "c17e92f408af3768b363ea226e158c5008371e383a2f963fcc565bd7ba28c899" => :mavericks
  end

  head do
    url "http://git.cern.ch/pub/CLHEP", :using => :git
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "cmake" => :build

  def install
    # CLHEP is super fussy and doesn't allow source tree builds
    dir = Dir.mktmpdir
    cd dir do
      args = std_cmake_args
      if build.stable?
        args << "#{buildpath}/CLHEP"
      else
        args << "#{buildpath}"
      end
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include <Vector/ThreeVector.h>

      int main() {
        CLHEP::Hep3Vector aVec(1, 2, 3);
        std::cout << "r: " << aVec.mag();
        std::cout << " phi: " << aVec.phi();
        std::cout << " cos(theta): " << aVec.cosTheta() << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-L#{lib}", "-lCLHEP", "-I#{include}/CLHEP",
           testpath/"test.cpp", "-o", "test"
    assert_equal "r: 3.74166 phi: 1.10715 cos(theta): 0.801784",
                 shell_output("./test").chomp
  end
end

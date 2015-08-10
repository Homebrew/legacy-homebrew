class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "http://proj-clhep.web.cern.ch/proj-clhep/"
  url "http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.2.0.8.tgz"
  sha256 "2be2a0386967720df8fc06e16ea0ccaf97822425b2f5e0d4919ba00ca057e892"

  bottle do
    cellar :any
    sha1 "5466fbee57b366a41bbcec814614ee236e39bed8" => :yosemite
    sha1 "bde270764522e4a1d99767ca759574a99485e5ac" => :mavericks
    sha1 "e77d0e5f516cb41ac061e1050c8f37d0fb65b796" => :mountain_lion
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

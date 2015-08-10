class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.2.0.8.tgz"
  sha256 "2be2a0386967720df8fc06e16ea0ccaf97822425b2f5e0d4919ba00ca057e892"

  bottle do
    cellar :any
    sha256 "2bd3b78f6bba745c5b629dba5b906e9c6e9291c587abe9a9b3468b7f69328309" => :yosemite
    sha256 "4b05bfd4b0eaea17f6df4956c080f8325063513ce6975ba8e0dadf00f95075ef" => :mavericks
    sha256 "4db90c676d11907ff0f4585c07060a9a411cf59a132ef3fedc958a40a5e43f11" => :mountain_lion
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

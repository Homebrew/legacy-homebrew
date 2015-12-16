class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "http://ompl.kavrakilab.org"
  url "https://bitbucket.org/ompl/ompl/downloads/ompl-1.0.0-Source.tar.gz"
  sha256 "9bb6242ca723ab49b31fc5ac343a580cb7e6229bcf876c503c235f4cdd75376b"

  bottle do
    sha256 "522f457084642ae54523cb24ed23d0e3bd3e816510f14feead1a8540fa0e99ed" => :el_capitan
    sha256 "6b3140c322f23aab0ac8e404b05d7b1768066dcd163e7fcaa4fd18e4c456fc72" => :yosemite
    sha256 "7d04b11a7f4d3121c8975d0bf92f5e779407d43fe46f1934c400583a6fcb6caa" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen" => :optional
  depends_on "ode" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <ompl/base/spaces/RealVectorBounds.h>
      #include <cassert>
      int main(int argc, char *argv[]) {
        ompl::base::RealVectorBounds bounds(3);
        bounds.setLow(0);
        bounds.setHigh(5);
        assert(bounds.getVolume() == 5 * 5 * 5);
      }
    EOS

    system ENV.cc, "test.cpp", "-L#{lib}", "-lompl", "-lstdc++", "-o", "test"
    system "./test"
  end
end

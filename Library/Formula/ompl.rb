class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "http://ompl.kavrakilab.org"
  url "https://bitbucket.org/ompl/ompl/downloads/ompl-1.1.0-Source.tar.gz"
  sha256 "4d141ad3aa322c65ee7ecfa90017a44a8114955316e159b635fae5b5e7db74f8"

  bottle do
    sha256 "5f29d3dc453e5f1d294333d250fed884b4a38fa91f0bb1048a14eaa58774b709" => :el_capitan
    sha256 "ee99c05b5f1084ded43e0cacf7bd3ca0a1d3046bf99c1d5faafd225db2fb3a61" => :yosemite
    sha256 "ab89e5350fdf56e044503f363c0e36ab689e45ef4f38806cf66f214908720838" => :mavericks
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

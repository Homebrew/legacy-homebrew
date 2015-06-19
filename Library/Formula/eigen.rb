class Eigen < Formula
  desc "C++ template library for linear algebra"
  homepage "http://eigen.tuxfamily.org/"
  url "http://bitbucket.org/eigen/eigen/get/3.2.4.tar.bz2"
  sha1 "64ea809acc449adbd8fe616def7d48ff4f0776a8"

  bottle do
    cellar :any
    sha1 "24b12f960b5d1b29814baee5d4ffd1f070d82b93" => :yosemite
    sha1 "4aeb1dc9374989f6721e655a51443c5fd92770bf" => :mavericks
    sha1 "69d4e8c691887006dfdae968ea8650c11cff3b51" => :mountain_lion
  end

  head "https://bitbucket.org/eigen/eigen", :using => :hg

  depends_on "cmake" => :build

  option :universal

  def install
    ENV.universal_binary if build.universal?
    mkdir "eigen-build" do
      args = std_cmake_args
      args.delete "-DCMAKE_BUILD_TYPE=None"
      args << "-DCMAKE_BUILD_TYPE=Release"
      args << "-Dpkg_config_libdir=#{lib}" << ".."
      system "cmake", *args
      system "make install"
    end
    (share/"cmake/Modules").install "cmake/FindEigen3.cmake"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include <Eigen/Dense>
      using Eigen::MatrixXd;
      int main()
      {
        MatrixXd m(2,2);
        m(0,0) = 3;
        m(1,0) = 2.5;
        m(0,1) = -1;
        m(1,1) = m(1,0) + m(0,1);
        std::cout << m << std::endl;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/eigen3", "-o", "test"
    assert_equal `./test`.split, %w[3 -1 2.5 1.5]
  end
end

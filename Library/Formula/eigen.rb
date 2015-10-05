class Eigen < Formula
  desc "C++ template library for linear algebra"
  homepage "http://eigen.tuxfamily.org/"
  url "https://bitbucket.org/eigen/eigen/get/3.2.6.tar.bz2"
  sha256 "8a3352f9a5361fe90e451a7305fb1896fc7f771dc16cc0edd8e6b157f52c343e"
  head "https://bitbucket.org/eigen/eigen", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "10492e31aa6f9b9764aae344198b0e1f55e644510a67d11e73ccdc685c8e32b4" => :el_capitan
    sha256 "925c934e9215bfaa438d69723e0c785eb92761a70591b4c9038263ebf81afb90" => :yosemite
    sha256 "964552d6a1463744bbdf26de9be97836f84b4f6fcf007559f0cfd913c0873847" => :mavericks
  end

  option :universal

  depends_on "cmake" => :build

  def install
    ENV.universal_binary if build.universal?
    mkdir "eigen-build" do
      args = std_cmake_args
      args << "-Dpkg_config_libdir=#{lib}" << ".."
      system "cmake", *args
      system "make", "install"
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

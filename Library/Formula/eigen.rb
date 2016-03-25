class Eigen < Formula
  desc "C++ template library for linear algebra"
  homepage "http://eigen.tuxfamily.org/"
  url "https://bitbucket.org/eigen/eigen/get/3.2.8.tar.bz2"
  sha256 "722a63d672b70f39c271c5e2a4a43ba14d12015674331790414fcb167c357e55"
  head "https://bitbucket.org/eigen/eigen", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "28e7161064b8d297df044d27b4677348d039ce45d3b4ea9a08bb856dc7c687ba" => :el_capitan
    sha256 "727c2ee0d0c4db05699a69b7df364441944361fdad5b74f885a0ac50935c7d9d" => :yosemite
    sha256 "d4b39c9f304c4f75e7b9a9b02bd69849f4e4400a9b7cc10df7d3f61b4777ab32" => :mavericks
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
    assert_equal %w[3 -1 2.5 1.5], shell_output("./test").split
  end
end

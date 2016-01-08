class Eigen < Formula
  desc "C++ template library for linear algebra"
  homepage "http://eigen.tuxfamily.org/"
  url "https://bitbucket.org/eigen/eigen/get/3.2.7.tar.bz2"
  sha256 "e58e1a11b23cf2754e32b3c5990f318a8461a3613c7acbf6035870daa45c2f3e"
  head "https://bitbucket.org/eigen/eigen", :using => :hg

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "79253659ae74f1bcf2293be0ddb1a31c8d763b2ddaed75de3a69ac6e9b234c2e" => :el_capitan
    sha256 "82ee2a1528e9d69a71bbf07d59f330dcbf067b5ec14553f4051cc69e52cb1d24" => :yosemite
    sha256 "d0ba02c5d3c6e5ea89679cb85bdddd28fafcdcf65174e2c123e2407d7f7b1c34" => :mavericks
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

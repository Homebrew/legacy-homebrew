class Eigen < Formula
  homepage "http://eigen.tuxfamily.org/"
  url "http://bitbucket.org/eigen/eigen/get/3.2.3.tar.bz2"
  sha1 "303e8241aaa879a328d675de368525a591c42e51"

  bottle do
    cellar :any
    sha1 "c5186ca59c192a26ace3775c6da18d7afc0a4669" => :yosemite
    sha1 "83ea196f29660928719ba2ea2537b8b674a0f3b5" => :mavericks
    sha1 "af6cc494f7082b18d88ffa61630d387575fd5e8f" => :mountain_lion
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

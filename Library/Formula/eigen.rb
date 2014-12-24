class Eigen < Formula
  homepage "http://eigen.tuxfamily.org/"
  url "http://bitbucket.org/eigen/eigen/get/3.2.3.tar.bz2"
  sha1 "303e8241aaa879a328d675de368525a591c42e51"

  bottle do
    cellar :any
    revision 1
    sha1 "5e6fb3f9fbd51f270285a5c9f2ed4f98b59b2279" => :yosemite
    sha1 "21743daea899324556b877aedb986a459a11e89d" => :mavericks
    sha1 "9654532e0b9f6762ee73c3938696cf95bc20a813" => :mountain_lion
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

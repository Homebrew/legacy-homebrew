require 'formula'

class Eigen < Formula
  homepage 'http://eigen.tuxfamily.org/'
  url 'http://bitbucket.org/eigen/eigen/get/3.2.2.tar.bz2'
  sha1 '1e1a85681777314805003db5469d1a00785c58df'

  bottle do
    cellar :any
    sha1 "5a64fff74d8c341cfcc36666810531261e0fd7a0" => :mavericks
    sha1 "28fb90c14195d63016ff9783cb4dd259fab257db" => :mountain_lion
    sha1 "7d09cae778259591337bf397b061fe7cd516c3a5" => :lion
  end

  head 'https://bitbucket.org/eigen/eigen', :using => :hg

  depends_on 'cmake' => :build

  option :universal

  def install
    ENV.universal_binary if build.universal?
    mkdir 'eigen-build' do
      args = std_cmake_args
      args.delete '-DCMAKE_BUILD_TYPE=None'
      args << '-DCMAKE_BUILD_TYPE=Release'
      args << "-Dpkg_config_libdir=#{lib}" << '..'
      system 'cmake', *args
      system 'make install'
    end
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

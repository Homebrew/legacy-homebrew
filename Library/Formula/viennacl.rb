class Viennacl < Formula
  desc "ViennaCL is a linear algebra library leveraging parallel computation."
  homepage "http://viennacl.sourceforge.net"
  url "https://downloads.sourceforge.net/project/viennacl/1.7.x/ViennaCL-1.7.0.tar.gz"
  sha256 "0dd062770f8cf92309b2473d5defc7a6b4c874170e350e6a7ad0f4c791c49eff"
  head "https://github.com/viennacl/viennacl-dev.git"

  depends_on "cmake" => :build
  depends_on :macos => :snow_leopard

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    libexec.install "#{buildpath}/examples/benchmarks/dense_blas-bench-cpu" => "test"
  end

  test do
    system "#{opt_libexec}/test"
  end
end

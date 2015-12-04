class Viennacl < Formula
  desc "ViennaCL is a linear algebra library leveraging parallel computation."
  homepage "http://viennacl.sourceforge.net"
  url "https://downloads.sourceforge.net/project/viennacl/1.7.x/ViennaCL-1.7.0.tar.gz"
  sha256 "0dd062770f8cf92309b2473d5defc7a6b4c874170e350e6a7ad0f4c791c49eff"
  head "https://github.com/viennacl/viennacl-dev.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0fa897aa195c281bc8aab8f14b5a824c9618f2bddc3fe859341d16a389223d52" => :el_capitan
    sha256 "4cf0ec1d9cd95e267de40fd83977fa499c01aff3eeb5cac09fad245a6ed67f2f" => :yosemite
    sha256 "9383c36ab840e0ce9599d283190711d7c3d6a25d1d3bd99970b409028ebb2bc9" => :mavericks
  end

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

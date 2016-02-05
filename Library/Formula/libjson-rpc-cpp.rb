class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v0.6.0.tar.gz"
  sha256 "98baf15e51514339be54c01296f0a51820d2d4f17f8c9d586f1747be1df3290b"

  bottle do
    cellar :any
    sha256 "b80a2f4618128083bbb25df7eb6b541eca7ae740ddbd931cd5e2067cc4366d6b" => :el_capitan
    sha256 "fd3c31a721cdb7bae7390e063f90a7979a3e0021ac1df1a2ed16957f2971ff00" => :yosemite
    sha256 "6daf0f22b4917f78226424660e28da52a6aec83183b604ebe94e35bc2a593e95" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "jsoncpp"
  depends_on "libmicrohttpd"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jsonrpcstub", "-h"
  end
end

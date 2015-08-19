class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v0.5.0.tar.gz"
  sha256 "e6d8d6c20517bb38eba9dba7f372e0a95432c4cbf55ec9b136ba841faa0a6d99"

  bottle do
    cellar :any
    sha256 "71bfa4140965e11dbcacf34178e8e582347fdd3d760c381fb546a48143883192" => :yosemite
    sha256 "7333b0e381028aa59c5660b36f022d35403fce0513b591a445724640156ac0b5" => :mavericks
    sha256 "eb44a7633c9c396957058181e51686715d824407a4d6c704579b08b27b044c88" => :mountain_lion
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

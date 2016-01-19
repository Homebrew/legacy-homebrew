class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v0.5.0.tar.gz"
  sha256 "e6d8d6c20517bb38eba9dba7f372e0a95432c4cbf55ec9b136ba841faa0a6d99"

  bottle do
    cellar :any
    revision 2
    sha256 "a9d7883a0a265f75495fe23c7414eab1201c49869e76f742437820f64bf7af77" => :el_capitan
    sha256 "5d951749422146185149e7e0d57a6ab11dd92d6b55f3bce21b7bd90617e33039" => :yosemite
    sha256 "07afaeb45d0cb55fe1cc1770498700046f238c2e01ba39544eb697b72965cd32" => :mavericks
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

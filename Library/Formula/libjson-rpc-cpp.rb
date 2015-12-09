class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v0.5.0.tar.gz"
  sha256 "e6d8d6c20517bb38eba9dba7f372e0a95432c4cbf55ec9b136ba841faa0a6d99"

  bottle do
    cellar :any
    revision 1
    sha256 "2aca5b29db5d3e191213780a6c8d811c78f5581bc8b4a9e28afe21170063d4a4" => :el_capitan
    sha256 "ada489878d1c4773d8c18cd491e978efebe5c609a46a7c09372490122bde4cba" => :yosemite
    sha256 "ae843e663ba29a0a2a26a1b2bee813816624781a2fe667a2df5e31883e4d7d02" => :mavericks
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

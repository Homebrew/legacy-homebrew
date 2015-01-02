class LibjsonRpcCpp < Formula
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v0.4.1.tar.gz"
  sha1 "199c5f262c41e51ff1d4f3625fb25543d97e852b"

  bottle do
    cellar :any
    sha1 "d6d672f1bbfb224d822788937fb7f9c8c545c875" => :yosemite
    sha1 "7cae25c4101d4b4b504b4cc8125734f64a7eccbc" => :mavericks
    sha1 "320fbd360648ffcf84fce6a33694fcb0ce3dbf07" => :mountain_lion
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

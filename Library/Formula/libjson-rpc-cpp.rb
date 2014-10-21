require "formula"

class LibjsonRpcCpp < Formula
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v0.3.tar.gz"
  sha1 "a5473ea664a99dcc5d44ebbccae4e9b0803f2e6e"

  depends_on "boost" => :build
  depends_on "argtable" => :build
  depends_on "jsoncpp" => :build
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    system "#{bin}/jsonrpcstub"
  end
end

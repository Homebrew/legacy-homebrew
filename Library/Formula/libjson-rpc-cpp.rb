class LibjsonRpcCpp < Formula
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v0.4.2.tar.gz"
  sha1 "a9e00bfdb1b6843897fb644caa114577c349e18c"

  bottle do
    cellar :any
    sha1 "f91d44d59eb889473db7d99eef593317f9f1c244" => :yosemite
    sha1 "4857b90795ae4cf8ee239139030356bc677a02e3" => :mavericks
    sha1 "5adfd6855401bb04f0db8191e339d7d2891f4a5b" => :mountain_lion
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

class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v0.6.0.tar.gz"
  sha256 "98baf15e51514339be54c01296f0a51820d2d4f17f8c9d586f1747be1df3290b"
  head "https://github.com/cinemast/libjson-rpc-cpp.git"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "ee8dff6076bfb9568a880345c424444ef0f725e7530482110e659cea25953672" => :el_capitan
    sha256 "4b69351cf61844128f7a0b53c0fb5871e5236daf80848131390dc8d15b7c7bd2" => :yosemite
    sha256 "43cb1b51c0126600b8cc057c7b5114b8888a16edde548cc1d2ca4d5dcc423945" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "jsoncpp"
  depends_on "libmicrohttpd"

  def install
    # https://github.com/cinemast/libjson-rpc-cpp/issues/153
    ENV.deparallelize

    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jsonrpcstub", "-h"
  end
end

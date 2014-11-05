require "formula"

class LibjsonRpcCpp < Formula
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v0.3.2.tar.gz"
  sha1 "37697f2647a1062158a7f3bb83b503195bf27363"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "jsoncpp"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jsonrpcstub"
  end
end

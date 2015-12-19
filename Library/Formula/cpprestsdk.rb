class Cpprestsdk < Formula
  desc "C++ libraries for cloud-based client-server communication"
  homepage "https://github.com/Microsoft/cpprestsdk"
  url "https://github.com/Microsoft/cpprestsdk/archive/v2.7.0.tar.gz"
  sha256 "d53593fda17bcac8f68af8bc3ba4ac638ea7e7480f43aa7f3350f6f200b0c63e"
  depends_on "boost"
  depends_on "openssl"
  depends_on "cmake" => :build

  def install
    system "cmake", "-DBUILD_TESTS=OFF", "-DBUILD_SAMPLES=OFF", "-DCMAKE_BUILD_TYPE=Release", "Release", *std_cmake_args
    system "getconf _NPROCESSORS_ONLN | make -j"
    system "make", "install"
  end

  test do
    system "false"
  end
end

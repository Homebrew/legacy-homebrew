class CppNetlib < Formula
  desc "C++ libraries for high level network programming"
  homepage "http://cpp-netlib.org"
  url "https://storage.googleapis.com/cpp-netlib-downloads/0.11.1/cpp-netlib-0.11.1-final.tar.bz2"
  version "0.11.1"
  sha256 "8f5a0bb7e5940490b4e409f9c805b752ee4b598e06d740d04adfc76eb5c8e23e"
  revision 1

  bottle do
    cellar :any
    sha256 "908f012404ef102a2c9d537bb09852f2b6547eb00f32a0694a7a65e634fc05c4" => :yosemite
    sha256 "63797d147576de712c1d4e02722767d8335239464fe3e28b09a15e07f33ef2d4" => :mavericks
    sha256 "a933931c06e160a3792e1d71cc0c12ae47b8ad058c37dffae5e92f217edd11f5" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  needs :cxx11

  def install
    ENV.cxx11

    system "cmake", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <boost/network/protocol/http/client.hpp>
      int main(int argc, char *argv[]) {
        using namespace boost::network;
        http::client client;
        http::client::request request("");
        return 0;
      }
    EOS
    flags = ["-stdlib=libc++", "-I#{include}", "-I#{Formula["boost"].include}", "-L#{lib}", "-L#{Formula["boost"].lib}", "-lboost_thread-mt", "-lboost_system-mt", "-lssl", "-lcrypto", "-lcppnetlib-client-connections", "-lcppnetlib-server-parsers", "-lcppnetlib-uri"] + ENV.cflags.to_s.split
    system ENV.cxx, "-o", "test", "test.cpp", *flags
    system "./test"
  end
end

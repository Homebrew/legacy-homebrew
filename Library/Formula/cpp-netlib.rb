require "formula"

class CppNetlib < Formula
  homepage "http://cpp-netlib.org"
  url "http://storage.googleapis.com/cpp-netlib-downloads/0.11.1/cpp-netlib-0.11.1RC2.tar.gz"
  sha1 "3d50619980f5fcab7baecfa0a34fc9e54a7f5884"

  depends_on "cmake" => :build
  depends_on "boost" => "c++11"
  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/'test.cpp').write <<-EOS.undent
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

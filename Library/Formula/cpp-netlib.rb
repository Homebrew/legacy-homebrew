class CppNetlib < Formula
  homepage "http://cpp-netlib.org"
  url "https://storage.googleapis.com/cpp-netlib-downloads/0.11.1/cpp-netlib-0.11.1-final.tar.bz2"
  sha1 "213ba700e534596b44409cd6d5738b959fe41746"

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

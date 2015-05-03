class CppNetlib < Formula
  homepage "http://cpp-netlib.org"
  url "https://storage.googleapis.com/cpp-netlib-downloads/0.11.1/cpp-netlib-0.11.1-final.tar.bz2"
  sha256 "8f5a0bb7e5940490b4e409f9c805b752ee4b598e06d740d04adfc76eb5c8e23e"

  bottle do
    sha1 "799f0fc4ecf5b9c266f429d700095c4439e1ff87" => :yosemite
    sha1 "cdadc6e7d4c4f721c694efaed258affc9c93b86f" => :mavericks
    sha1 "4d839cdf6ed3b92a5e4c6c1738ff058b979c4e21" => :mountain_lion
  end

  depends_on "cmake" => :build

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

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

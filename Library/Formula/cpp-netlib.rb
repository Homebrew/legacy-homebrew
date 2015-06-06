class CppNetlib < Formula
  desc "C++ libraries for high level network programming"
  homepage "http://cpp-netlib.org"
  url "https://storage.googleapis.com/cpp-netlib-downloads/0.11.1/cpp-netlib-0.11.1-final.tar.bz2"
  sha256 "8f5a0bb7e5940490b4e409f9c805b752ee4b598e06d740d04adfc76eb5c8e23e"
  version "0.11.1"

  bottle do
    sha256 "c6d9909b1d7a4402782ed86d80c97c612f24e8893e266a7064362dc0a6323324" => :yosemite
    sha256 "8cd73fdc6597e1223f1cf12a0908c1d4c469f1a0dddf7f88d6f5d522f59129c3" => :mavericks
    sha256 "1409987a309cdf2a03d8161c6357770626d265d622101bf246011290126de2f9" => :mountain_lion
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

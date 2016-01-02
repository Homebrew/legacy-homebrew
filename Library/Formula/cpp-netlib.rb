class CppNetlib < Formula
  desc "C++ libraries for high level network programming"
  homepage "http://cpp-netlib.org"
  url "http://downloads.cpp-netlib.org/0.11.2/cpp-netlib-0.11.2-final.tar.gz"
  version "0.11.2"
  sha256 "71953379c5a6fab618cbda9ac6639d87b35cab0600a4450a7392bc08c930f2b1"

  bottle do
    cellar :any_skip_relocation
    sha256 "5669a528afe56b310179af07d0191b96491f90a2365b5b9e7f1d26daa011b463" => :el_capitan
    sha256 "2ddb407f33dd6a8c8ec1e3a8afd67a3afb1666f843794e72632f203fb5b42ecb" => :yosemite
    sha256 "0913efd07660f359ee7d043f06a25ccb9fc3010f42b15f4dbd43b558f2161bb1" => :mavericks
    sha256 "093cc615abf08eeb6d698d85e9d4bb8003e536548f925246d86baa7f1ec45506" => :mountain_lion
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

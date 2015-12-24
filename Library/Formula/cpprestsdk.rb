class Cpprestsdk < Formula
  desc "C++ libraries for cloud-based client-server communication"
  homepage "https://github.com/Microsoft/cpprestsdk"
  url "https://github.com/Microsoft/cpprestsdk/archive/v2.7.0.tar.gz"
  sha256 "d53593fda17bcac8f68af8bc3ba4ac638ea7e7480f43aa7f3350f6f200b0c63e"
  depends_on "boost"
  depends_on "openssl"
  depends_on "cmake" => :build

  def install
    system "cmake", "-DBUILD_SAMPLES=OFF", "Release", *std_cmake_args
    system "make", "install"
  end
  test do
    (testpath/"test.cc").write <<-EOS.undent
      #include <iostream>
      #include <cpprest/http_client.h>
      int main() {
        web::http::client::http_client client(U("https://github.com/"));
        std::cout << client.request(web::http::methods::GET).get().extract_string().get() << std::endl;
      }
    EOS
    flags = ["-stdlib=libc++", "-std=c++11", "-I#{include}", "-I#{Formula["boost"].include}", "-I/usr/local/opt/openssl/include", "-L#{lib}", "-L/usr/local/opt/openssl/lib", "-L#{Formula["boost"].lib}", "-lssl", "-lcrypto", "-lboost_random", "-lboost_chrono", "-lboost_thread-mt", "-lboost_system-mt", "-lboost_regex", "-lboost_filesystem", "-lcpprest"] + ENV.cflags.to_s.split
    system ENV.cxx, "-o", "test_cpprest", "test.cc", *flags
    system "./test_cpprest"
  end
end

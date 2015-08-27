class Zmqpp < Formula
  desc "High-level C++ binding for zeromq"
  homepage "https://zeromq.github.io/zmqpp/"
  url "https://github.com/zeromq/zmqpp/archive/4.1.2.tar.gz"
  sha256 "831ad02df64034268d910c30f9fb1b1e631ad810182951af9d7d622650831eb5"

  depends_on "zeromq"

  needs :cxx11

  def install
    ENV.cxx11
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <zmqpp/zmqpp.hpp>
      int main() {
        zmqpp::frame frame;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lzmqpp", "-o", "test", "-std=c++11", "-stdlib=libc++", "-lc++"
    system "./test"
  end
end

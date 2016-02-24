class Zmqpp < Formula
  desc "High-level C++ binding for zeromq"
  homepage "https://zeromq.github.io/zmqpp/"
  url "https://github.com/zeromq/zmqpp/archive/4.1.2.tar.gz"
  sha256 "831ad02df64034268d910c30f9fb1b1e631ad810182951af9d7d622650831eb5"

  bottle do
    cellar :any
    sha256 "b685138f83319a736cac81faf480f95fd08b4634c8b19e785e611b39ebbfe39c" => :yosemite
    sha256 "9e4a0cf143c037cdc1b5c8440f09ab2b67e79edb78b3b2d638cc4cb523fe7d1b" => :mavericks
    sha256 "2392c3090822256c05a35a2e09e99096512838f51704281a2a3b26af10739813" => :mountain_lion
  end

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

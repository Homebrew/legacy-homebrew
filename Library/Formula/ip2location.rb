require "formula"

class Ip2location < Formula
  homepage "http://www.ip2location.com"
  url "https://github.com/velikanov/ip2location/archive/v7.0.0.tar.gz"
  sha1 "b8742cbe4b2cb2f2c4992da869498454fcb52847"

  def install
    system "make"
    system "make", "install"
  end

  test do
    system "test /usr/local/lib/libIP2Location.dylib"
    mv "libIP2Location.dylib", lib/"libIP2Location.dylib"
  end
end

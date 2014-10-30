require "formula"

class Ip2location < Formula
  homepage "http://www.ip2location.com"
  url "https://github.com/velikanov/ip2location/archive/v7.0.0.2.tar.gz"
  sha1 "7a4d0b3e7b29ca2ec90a92b7901f22ecb3c6f50e"

  def install
    system "./configure", "--prefix=#{HOMEBREW_PREFIX}/lib"
    system "make"
    system "make", "install"
  end

  test do
    system "test #{HOMEBREW_PREFIX}/lib/libIP2Location.dylib"
  end
end

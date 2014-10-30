require "formula"

class Ip2location < Formula
  homepage "http://www.ip2location.com"
  url "https://github.com/velikanov/ip2location/archive/v7.0.0.3.tar.gz"
  sha1 "5965fbc7973f3359a2352ae468828f473f10fc5c"

  def install
    system "./configure", "--prefix=#{HOMEBREW_PREFIX}"
    system "make"
    system "make", "install"
  end

  test do
    system "test #{HOMEBREW_PREFIX}/lib/libIP2Location.dylib"
  end
end

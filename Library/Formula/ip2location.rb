require "formula"

class Ip2location < Formula
  homepage "http://www.ip2location.com"
  url "https://github.com/velikanov/ip2location/archive/v7.0.0.1.tar.gz"
  sha1 ""

  def install
    system "make"
    mv "libIP2Location.dylib", "#{HOMEBREW_PREFIX}/lib/libIP2Location.dylib"
  end

  test do
    system "test #{HOMEBREW_PREFIX}/lib/libIP2Location.dylib"
  end
end

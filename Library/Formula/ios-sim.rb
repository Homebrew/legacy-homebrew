require "formula"

class IosSim < Formula
  homepage "https://github.com/phonegap/ios-sim"
  url "https://github.com/phonegap/ios-sim/archive/3.0.0.tar.gz"
  sha1 "e5b5dd2a622549f105935c3f6fc3cce93aba7b45"
  head "https://github.com/phonegap/ios-sim.git"

  bottle do
    cellar :any
    sha1 "a3d4fca43c68809b156490b018190df8059a0ebf" => :mavericks
    sha1 "747cd81a2dfae3c14a4d41ff286d60dc9c939d5b" => :mountain_lion
  end

  depends_on :macos => :mountain_lion

  def install
    rake "install", "prefix=#{prefix}"
  end
end

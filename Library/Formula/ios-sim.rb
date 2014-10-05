require "formula"

class IosSim < Formula
  homepage "https://github.com/phonegap/ios-sim"
  url "https://github.com/phonegap/ios-sim/archive/3.0.0.tar.gz"
  sha1 "e5b5dd2a622549f105935c3f6fc3cce93aba7b45"
  head "https://github.com/phonegap/ios-sim.git"

  bottle do
    cellar :any
    sha1 "3f28d1596a8d019ecb4fc70f758190a21e56ebcc" => :mavericks
    sha1 "9ed5958db90bb227a0f0afc878f4cfb4a835fcca" => :mountain_lion
  end

  depends_on :macos => :mountain_lion

  def install
    rake "install", "prefix=#{prefix}"
  end
end

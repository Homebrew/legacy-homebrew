require "formula"

class IosSim < Formula
  homepage "https://github.com/phonegap/ios-sim"
  url "https://github.com/phonegap/ios-sim/archive/2.0.1.tar.gz"
  sha1 "df15d7f49561b92f8d3bf8832db60b83d7ce355e"
  head "https://github.com/phonegap/ios-sim.git"

  bottle do
    cellar :any
    sha1 "3f28d1596a8d019ecb4fc70f758190a21e56ebcc" => :mavericks
    sha1 "9ed5958db90bb227a0f0afc878f4cfb4a835fcca" => :mountain_lion
    sha1 "4ad30f386778b5e395755109ec50fb725066099c" => :lion
  end

  depends_on :macos => :lion

  def install
    rake "install", "prefix=#{prefix}"
  end
end

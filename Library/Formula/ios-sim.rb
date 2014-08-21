require "formula"

class IosSim < Formula
  homepage "https://github.com/phonegap/ios-sim"
  url "https://github.com/phonegap/ios-sim/archive/2.0.1.tar.gz"
  sha1 "df15d7f49561b92f8d3bf8832db60b83d7ce355e"
  head "https://github.com/phonegap/ios-sim.git"

  depends_on :macos => :lion

  def install
    rake "install", "prefix=#{prefix}"
  end
end

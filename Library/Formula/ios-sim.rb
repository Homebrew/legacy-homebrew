class IosSim < Formula
  desc "Command-line application launcher for the iOS Simulator"
  homepage "https://github.com/phonegap/ios-sim"
  url "https://github.com/phonegap/ios-sim/archive/3.1.1.tar.gz"
  sha256 "559e18f198d4c5298666fee8face0ac8d8dbce034d2c5241093bdd1d43014cb7"
  head "https://github.com/phonegap/ios-sim.git"

  bottle do
    cellar :any
    sha1 "4b4c830f96af400e593fe1457f8162774589f67d" => :yosemite
    sha1 "84de583b7e287ddab20e8ef10e03a97ad2a4d5af" => :mavericks
    sha1 "f559ce57478e9aaebb8eabb6366fa12629e8cf3a" => :mountain_lion
  end

  depends_on :macos => :mountain_lion

  def install
    rake "install", "prefix=#{prefix}"
  end
end

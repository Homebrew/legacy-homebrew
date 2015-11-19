class IosSim < Formula
  desc "Command-line application launcher for the iOS Simulator"
  homepage "https://github.com/phonegap/ios-sim"
  url "https://github.com/phonegap/ios-sim/archive/3.1.1.tar.gz"
  sha256 "559e18f198d4c5298666fee8face0ac8d8dbce034d2c5241093bdd1d43014cb7"
  head "https://github.com/phonegap/ios-sim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0bf22dbfe7f9078ea8afca0a71d5a3e5edfca5c69cbcf31f45c6d25660f760a" => :el_capitan
    sha256 "7c48ffdc5c34bf918f982e95219f6dac8af3d6e194806acaa08545ec89c13cde" => :yosemite
    sha256 "e9bbc65c7817322cb927e998a401bdeea7c8669f2ad10fb963f5eed91f3b30b9" => :mavericks
    sha256 "2182681c195d4a616f9a3975ea986de04d7d5b4c434844e503b83e4b18cd035c" => :mountain_lion
  end

  depends_on :macos => :mountain_lion

  def install
    rake "install", "prefix=#{prefix}"
  end
end

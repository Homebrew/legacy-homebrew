class Tortle < Formula
  desc "A tiny utility for easily enabling and disabling Tor on OS X"
  homepage "https://thrifus.github.io/Tortle"
  url "https://github.com/thrifus/Tortle/archive/1.0.1.tar.gz"
  version "1.0.1"
  sha256 "01328162a017868f713e04a65fa7ea3315adb285046edbf13917fd26e849cca4"

  depends_on "tor"
  def install
    bin.install "tortle"
  end

  test do
    system "tortle"
  end
end

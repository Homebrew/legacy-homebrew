class BrewPip < Formula
  desc "Install pip packages as homebrew formulas"
  homepage "https://github.com/hanxue/brew-pip"
  url "https://github.com/hanxue/brew-pip/archive/0.4.1.tar.gz"
  sha256 "9049a6db97188560404d8ecad2a7ade72a4be4338d5241097d3e3e8e215cda28"

  bottle :unneeded

  def install
    bin.install "bin/brew-pip"
  end
end

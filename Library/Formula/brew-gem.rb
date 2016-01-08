class BrewGem < Formula
  desc "Install rubygems as homebrew formulae"
  homepage "https://github.com/sportngin/brew-gem"
  url "https://github.com/sportngin/brew-gem/archive/v0.6.1.tar.gz"
  sha256 "b3dd161d5fa6a643d97b08cad514f0c8fdba8b8f44ff80a70f6a5090cf02cdfd"

  bottle :unneeded

  def install
    bin.install "bin/brew-gem"
  end
end

class BrewGem < Formula
  desc "Install rubygems as homebrew formulae"
  homepage "https://github.com/sportngin/brew-gem"
  url "https://github.com/sportngin/brew-gem/archive/v0.6.0.tar.gz"
  sha256 "1de2d4695f5b3108a96b459e7f8697035c01cebee84bbfaa260ac10e0aca4478"

  bottle :unneeded

  def install
    bin.install "bin/brew-gem"
  end
end

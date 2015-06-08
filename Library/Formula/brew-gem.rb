require "formula"

class BrewGem < Formula
  desc "Install rubygems as homebrew formulas"
  homepage "https://github.com/sportngin/brew-gem"
  url "https://github.com/sportngin/brew-gem/archive/0.5.1.tar.gz"
  sha1 "37b77607119f9ca95a7d28c231bb4f3bb3fe1c3f"

  def install
    bin.install "bin/brew-gem"
  end
end

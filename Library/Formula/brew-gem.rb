class BrewGem < Formula
  desc "Install rubygems as homebrew formulas"
  homepage "https://github.com/sportngin/brew-gem"
  url "https://github.com/sportngin/brew-gem/archive/v0.5.2.tar.gz"
  sha256 "77ed5b2e4f3b15a9d316691c9e0fb8c25367d313d7f6426d03d733866ec4f75f"

  def install
    bin.install "bin/brew-gem"
  end
end

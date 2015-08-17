class BrewGem < Formula
  desc "Install rubygems as homebrew formulas"
  homepage "https://github.com/sportngin/brew-gem"
  url "https://github.com/sportngin/brew-gem/archive/0.5.1.tar.gz"
  sha256 "6faad4646d65002e6d13af8da48080a9fe9065acb32353058ed1e78cebfd2025"

  def install
    bin.install "bin/brew-gem"
  end
end

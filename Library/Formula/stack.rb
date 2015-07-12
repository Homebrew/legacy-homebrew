class Stack < Formula
  desc "The Haskell Tool Stack"
  homepage "https://www.stackage.org/"
  url "https://github.com/commercialhaskell/stack/releases/download/v0.1.2.0/stack-0.1.2.0-x86_64-osx.gz"
  sha256 "6e1039d9c5144fb03dbfb1f569a830724593191305998e9be87579d985feb36c"

  def install
    bin.install "stack-0.1.2.0-x86_64-osx" => "stack"
  end
end

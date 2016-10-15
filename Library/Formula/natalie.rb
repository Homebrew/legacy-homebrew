class Natalie < Formula
  homepage "https://github.com/krzyzanowskim/Natalie#readme"
  url "https://github.com/krzyzanowskim/Natalie/archive/0.1.tar.gz"
  version "0.1"
  sha256 "943dab1b7ac16555ec3047983a3c397f7ebe7559d3c098c02a6ee6d8e966655e"

  def install
    bin.install 'natalie.swift'
  end
end

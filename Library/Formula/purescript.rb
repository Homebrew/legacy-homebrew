require "formula"

class Purescript < Formula
  homepage "http://www.purescript.org/"
  url "https://github.com/purescript/purescript/releases/download/v0.6.1.2/macos.tar.gz"
  sha1 "43899cb5ddb681911e4a6c716f464f1400bdccc1"
  version "0.6.1.2"

  def install
    bin.install %w(psc psc-docs psc-make psci)
    doc.install %w(LICENSE README)
  end

  test do
    system "sh", "-c", "echo module Main where | psc --no-prelude -s"
  end
end

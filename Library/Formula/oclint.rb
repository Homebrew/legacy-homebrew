require "formula"

class Oclint < Formula
  homepage "http://oclint.org/"
  url "http://archives.oclint.org/releases/0.7/oclint-0.7-x86_64-apple-darwin-10.tar.gz"
  sha1 "867751f9e1b73515c22a014b22592b31c92f81bb"
  version "0.7"

  def install
    bin.install Dir["bin/oclint*"]
    lib.install 'lib'
  end

  test do
    system "oclint"
    system "oclint-json-compilation-database"
    system "oclint-xcodebuild"
  end
end

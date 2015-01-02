require "formula"

class Ccextractor < Formula
  homepage "http://ccextractor.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ccextractor/ccextractor/0.74/ccextractor.src.0.74.zip"
  sha1 "3118533154e23078675523d3edbca8a657eda54c"

  def install
    cd "mac"
    system "bash ./build.command"
    bin.install "ccextractor"
  end
end

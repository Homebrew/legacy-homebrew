require "formula"

class Odt2txt < Formula
  homepage "http://stosberg.net/odt2txt/"
  url "https://github.com/barak/odt2txt/archive/master.tar.gz" # Use the version with Mac Makefile support
  sha1 "c9b2398ac320814bea3eda7147f87ccfb70fc493"
  version "0.4"

  def install
    system "make"
    bin.install("odt2txt")
    man1.install("odt2txt.1")
  end

  test do
    system "odt2txt"
  end
end

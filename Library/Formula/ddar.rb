require "formula"

class Ddar < Formula
  homepage "http://www.synctus.com/ddar/"
  url "https://github.com/basak/ddar/archive/v1.0.tar.gz"
  sha1 "5f8b508f93031b1be217441b45fff27a6b630a49"

  depends_on "xmltoman" => :build
  depends_on :python
  depends_on "protobuf"

  def install
    system "make", "-f", "Makefile.prep", "pydist"
    system "python", "setup.py", "install", "--prefix=#{prefix}", "--single-version-externally-managed", "--record=installed.txt"
  end

  test do
    system "ddar", "-h"
  end
end

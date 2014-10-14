require "formula"

class Httpry < Formula
  homepage "http://dumpsterventures.com/jason/httpry/"
  url "http://dumpsterventures.com/jason/httpry/httpry-0.1.8.tar.gz"
  sha1 "163dcd1ab8cb2e8cef3cda2d7f0dea1b04deb338"

  depends_on :bsdmake

  def install
    system "bsdmake"
    bin.install "httpry"
    man1.install "httpry.1"
  end
end

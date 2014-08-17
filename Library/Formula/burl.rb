require "formula"

class Burl < Formula
  homepage "https://github.com/visionmedia/burl"
  url "https://github.com/visionmedia/burl/archive/1.0.1.tar.gz"
  sha1 "ee21caa267af9e3c679f3c4c38d4ccd6ba2dd655"

  def install
    bin.install "bin/burl"
  end

  test do
    system "#{bin}/burl", "-I", "github.com"
  end
end

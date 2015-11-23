class Burl < Formula
  desc "Shell script wrapper that offers helpful shortcuts for curl(1)"
  homepage "https://github.com/visionmedia/burl"
  url "https://github.com/visionmedia/burl/archive/1.0.1.tar.gz"
  sha256 "634949b7859ddf7c75a89123608998f8dac8ced8c601fa2c2717569caeaa54e5"

  bottle :unneeded

  def install
    bin.install "bin/burl"
  end

  test do
    system "#{bin}/burl", "-I", "github.com"
  end
end

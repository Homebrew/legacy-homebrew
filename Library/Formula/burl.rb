require "formula"

class Burl < Formula
  homepage "https://github.com/visionmedia/burl"
  url "https://github.com/visionmedia/burl/archive/1.0.1.zip"
  sha1 "1c082369f45dd1a9236f7cc078608578e8b06dc1"

  def install
    bin.install 'bin/burl'
  end

  test do
    system "#{bin}/burl", "-I", "github.com"
  end
end

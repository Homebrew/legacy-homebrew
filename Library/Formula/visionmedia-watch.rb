require "formula"

class VisionmediaWatch < Formula
  homepage "https://github.com/visionmedia/watch"
  url "https://github.com/visionmedia/watch/archive/0.3.1.tar.gz"
  sha1 "f5dc414eea6c5b079535c843e54ba638bcf0172b"

  head "https://github.com/visionmedia/watch.git"

  conflicts_with "watch"

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end
end

require "formula"

class VisionmediaWatch < Formula
  homepage "https://github.com/visionmedia/watch"
  url "https://github.com/visionmedia/watch/archive/0.3.1.tar.gz"
  sha1 "f5dc414eea6c5b079535c843e54ba638bcf0172b"

  head "https://github.com/visionmedia/watch.git"

  bottle do
    cellar :any
    sha1 "8491a4f2601bbb56bb071ea7c800d529d97e3b85" => :mavericks
    sha1 "6fd809bb5216c0e1d75e7ea43c52a55b6bd52f0b" => :mountain_lion
    sha1 "4e046b6c5fdc152127cb968b53324cc3fe362745" => :lion
  end

  conflicts_with "watch"

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end
end

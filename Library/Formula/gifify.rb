require "formula"

class Gifify < Formula
  desc "Turn movies into GIFs"
  homepage "https://github.com/jclem/gifify"
  head "https://github.com/jclem/gifify.git"
  url "https://github.com/jclem/gifify/archive/v3.0.tar.gz"
  sha1 "cd374bfad80e024af2b6cce6558474bdffef3f17"

  depends_on "ffmpeg"
  depends_on "imagemagick"

  def install
    bin.install "gifify.sh" => "gifify"
  end

  test do
    system "ffmpeg", "-f", "lavfi", "-i", "testsrc", "-t", "1", "-c:v", "libx264", "test.m4v"
    system "#{bin}/gifify", "-n", "test.m4v"
  end
end

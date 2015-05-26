require "formula"

class Gifify < Formula
  homepage "https://github.com/jclem/gifify"
  head "https://github.com/jclem/gifify.git"
  url "https://github.com/jclem/gifify/archive/v2.0.tar.gz"
  sha1 "fa8ef89b94f9f0e0d98ffe8fd83365d6e16bfced"

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

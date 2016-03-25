class Gifify < Formula
  desc "Turn movies into GIFs"
  homepage "https://github.com/jclem/gifify"
  url "https://github.com/jclem/gifify/archive/v3.0.tar.gz"
  sha256 "1fc7c77672b1f93b009b39b44beba44d0ea0573cf21f7c906c3ec97d663168e5"
  revision 1
  head "https://github.com/jclem/gifify.git"

  bottle :unneeded

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

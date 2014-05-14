require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.05.13/youtube-dl-2014.05.13.tar.gz"
  sha1 "75a1ab1ec0ea7eb3dc241fc6dc7c35811266f274"

  bottle do
    cellar :any
    sha1 "f786110ada74a12f50b5f82e6b26d355ac8d10b0" => :mavericks
    sha1 "6123c8362bd89c3f5e7cbd7e466f025341350d8a" => :mountain_lion
    sha1 "0f2d46f6e424d11f22f0833d9a8a84064f39ee90" => :lion
  end

  depends_on "rtmpdump" => :optional

  def install
    system "make", "youtube-dl", "PREFIX=#{prefix}"
    bin.install "youtube-dl"
    man1.install "youtube-dl.1"
    bash_completion.install "youtube-dl.bash-completion"
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "http://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end

require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.09.24/youtube-dl-2014.09.24.tar.gz"
  sha1 "bec02c15027c89b4940d788cd9f73d7d5a336e2b"

  bottle do
    cellar :any
    sha1 "aaa1af8a9b78ac297f5e8d61b60a628c12e8bf5d" => :mavericks
    sha1 "28f7821d8528abb04558578e4648bff1f8b8664f" => :mountain_lion
    sha1 "557d55db5ec4954d0b9e8a6806ca84e2290f98b6" => :lion
  end

  head do
    url "https://github.com/rg3/youtube-dl.git"
    depends_on "pandoc" => :build
  end

  depends_on "rtmpdump" => :optional

  def install
    system "make", "PREFIX=#{prefix}"
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

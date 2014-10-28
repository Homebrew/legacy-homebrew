require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.10.27/youtube-dl-2014.10.27.tar.gz"
  sha1 "f49040780869cd4747fecc1682dbcfc2f19b7bd0"

  bottle do
    cellar :any
    sha1 "79cfd9b582a3484cde57b2335cdeb2a195fe281d" => :yosemite
    sha1 "e4b165a70a4b03af4fee41bc618de5a9d87c5bda" => :mavericks
    sha1 "26bdb0036c78e91cd6b874bb944d36b6b70c33ae" => :mountain_lion
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
    zsh_completion.install "youtube-dl.zsh" => "_youtube-dl"
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "http://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end

require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.02.21/youtube-dl-2015.02.21.tar.gz"
  sha256 "3694979c2296e182d92be8e6c5b7d90fb95b9d4d6f070d3912856dcb264ca03b"

  bottle do
    cellar :any
    sha1 "aa6889d9bb8e74fa8316c8aeafe9038c14817808" => :yosemite
    sha1 "31169d0ccb1b3f6696087925df86fddba6525e50" => :mavericks
    sha1 "f15355712e5fb2a65fccde5288dfb773c6452aa3" => :mountain_lion
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
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "http://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end

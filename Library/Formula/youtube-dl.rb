require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.04.28/youtube-dl-2015.04.28.tar.gz"
  sha256 "08748955f1a511d1c118d4241cc8380237383afb76ce5e547d73fedd5aee968f"

  bottle do
    cellar :any
    sha256 "ca836363403dbbbb9fcfcb57578437c478186cc8a82f708775c83dd3eba98b1a" => :yosemite
    sha256 "bb6bb851388157cef5eb62a88df1060ae12ef2d37df6e97b2a5186b51ae4b582" => :mavericks
    sha256 "bfb035f1455c638c91d50d19ec70001e7aa643905ffac971c2d3a6e8d9e72f8e" => :mountain_lion
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

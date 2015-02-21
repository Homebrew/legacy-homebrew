require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.02.20/youtube-dl-2015.02.20.tar.gz"
  sha256 "3bfef8d0202b613ea4b03c40642c8d33eb174cd6360f47bd6d0a83a0dae8622b"

  bottle do
    cellar :any
    sha1 "b45c55eba29cf7a2cc4179365559d3f03d7fbe97" => :yosemite
    sha1 "8ad83ef4875eaf9bb671297d2736b9ee4468efce" => :mavericks
    sha1 "6a9d34c4ab2aa0cdeb5f7cfe472c8b0b0d8a2531" => :mountain_lion
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

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.08.06.1/youtube-dl-2015.08.06.1.tar.gz"
  sha256 "efd25b9827851a5b8f7108437ea4d84f778702e59fcf85e37e9e0933b8a5c908"

  bottle do
    cellar :any
    sha256 "50de0a8e41b5dbe13d0bf481867f9a9679673ba2268f3241fc7d7dba1845498e" => :yosemite
    sha256 "9069a8b605b41159e05cdd5ff1b0c15faf1d1dfe721e1e2ea44f26bd87591a6f" => :mavericks
    sha256 "ce00b92282e02865172bccc280736959841d4d64dcb2dd13ea50e5189877e5d0" => :mountain_lion
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
    fish_completion.install "youtube-dl.fish"
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end

require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.04.03/youtube-dl-2015.04.03.tar.gz"
  sha256 "0521a15a24a9b620728a2f45ea9163ca74660ed443781b6e69b4e06d36d7bf59"

  bottle do
    cellar :any
    sha256 "f427f418259cb64c885b60c7dd194fc223bdff9520919ac5fb347abf004cd0d1" => :yosemite
    sha256 "35511a7c5c510ddb57ccdb5a61e45d61ba8945116dbc11ae91be278561e9722d" => :mavericks
    sha256 "8a3c21709b81d83a74791e507c50327f7b31f461123191b84ec9c0ccbc7ef563" => :mountain_lion
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

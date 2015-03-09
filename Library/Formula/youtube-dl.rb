require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.03.09/youtube-dl-2015.03.09.tar.gz"
  sha256 "bf87403cccf292d6133d358ea0cf6c74a5daef095d6a9f0b9becffd6d3a9b757"

  bottle do
    cellar :any
    sha1 "890238440551cdc2151c837d19ef85da48bff295" => :yosemite
    sha1 "c4c4108e140aa8b39386df2553f472f5faa57275" => :mavericks
    sha1 "7618da485e69cc2514c631ad2c7d039a1c903e1b" => :mountain_lion
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

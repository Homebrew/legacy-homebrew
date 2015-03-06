require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.03.03.1/youtube-dl-2015.03.03.1.tar.gz"
  sha256 "31e4dd019c1564f9a2b9ad187b461d2fd0c9d1fa3f636ea36d5dd970fb77f539"

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

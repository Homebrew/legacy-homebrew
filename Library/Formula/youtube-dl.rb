require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.02.23.1/youtube-dl-2015.02.23.1.tar.gz"
  sha256 "f17925d3f728c209b5d2cdca814004180599c9ba9ddaac7fb10fbd1c1a09bb74"

  bottle do
    cellar :any
    sha1 "8b93749d2b77d745722fdf71a191bc1c8a8fa1c5" => :yosemite
    sha1 "3a6561cca9c3502b673166c7d003154d55d7c124" => :mavericks
    sha1 "0cf68def2952078e0e40ac9f97fd98207a18619b" => :mountain_lion
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

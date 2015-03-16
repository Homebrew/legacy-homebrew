require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.03.15/youtube-dl-2015.03.15.tar.gz"
  sha256 "ff7803e12b803ebefd8bc6639add23608dd7ac40f68b9ea00a700a29f9516b85"

  bottle do
    cellar :any
    sha256 "17319a8d69e07e0aae2af36b6872505931bfd029e8f51fc0400b6fb07d667497" => :yosemite
    sha256 "4611d070d29808032c18b7f5bd71ea2b6d0b2cf2690c029ece8a4831a15dd411" => :mavericks
    sha256 "5a1c41faaddd85358382d90776a4e6842055e6b4bb7c214318a3a047724c882b" => :mountain_lion
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

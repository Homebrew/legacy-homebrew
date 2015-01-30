require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.01.30.2/youtube-dl-2015.01.30.2.tar.gz"
  sha256 "95268ab14425c5ab1d13b338400d9611f0b06d64812c7ed44c2c3e4c8ae8d503"

  bottle do
    cellar :any
    sha1 "4f88e4be7a659e167c935086043eaba037a22617" => :yosemite
    sha1 "e84b0a7625b89559f8feb09b90ed7b9755526918" => :mavericks
    sha1 "cd4e8daa66a79974f34777bc8a3235064628e4db" => :mountain_lion
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

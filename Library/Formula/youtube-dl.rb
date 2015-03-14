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
    sha256 "2a0215ee014701ce5b7f342802d37cb3a2b7c20864c5cc23c27a4350beb9fed6" => :yosemite
    sha256 "ed541cea5b64bc9a6de5808de5b9788b25172e2eab0c05eaf8eacd2b969d4cc0" => :mavericks
    sha256 "232e3ac4ab260820a8ef7264cbca7921f48ca39cc434b37b6c7d1a2bf963120a" => :mountain_lion
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

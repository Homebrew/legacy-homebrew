require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.02.19.2/youtube-dl-2015.02.19.2.tar.gz"
  sha256 "f5eceb0059c7be400d838e64d1b61d49086cd9c23ffe52cf2d5ff12133853b23"

  bottle do
    cellar :any
    sha1 "48153a553a7ca092371ea9bd521d2b6079913515" => :yosemite
    sha1 "a157deb81c7b9d75a8331e9c3cca6bea64dbb9c4" => :mavericks
    sha1 "7d9d9c13251a785246fabe0a9cc3ffea26fbcccc" => :mountain_lion
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

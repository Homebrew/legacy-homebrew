require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.03.28/youtube-dl-2015.03.28.tar.gz"
  sha256 "4333a9e1f5c44a084cc4df6b24676bbc0a6847bce3cf8ebc03b294a97c7df1d1"

  bottle do
    cellar :any
    sha256 "5fce22272098f68e9419ae7ad2759a7ffe2b089fa4e86d00ff293b25e39d1824" => :yosemite
    sha256 "fa098bdaa7a48dbd5c6b7413c5a8e18295b319421719ab5c93cdb6249d67a5b8" => :mavericks
    sha256 "823c452e61153888c66d887f6908ca607dcf4ebfec8ccbdff90f4570a4649b29" => :mountain_lion
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

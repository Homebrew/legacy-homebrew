require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.12.17.2/youtube-dl-2014.12.17.2.tar.gz"
  sha256 "302cc64b5a283f60a1b34a5ccf0f09964bf64aa29c5996c945065a72016f68fa"

  bottle do
    cellar :any
    sha1 "9c85b470a1a9068805dd52b5ec451dab97a1b660" => :yosemite
    sha1 "c75d529ab1e25bb88f13036b48a2e714296141a8" => :mavericks
    sha1 "523569044e530341726d07ee659ceeacebc149b7" => :mountain_lion
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
    "To use post-processing options, `brew install ffmpeg`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "http://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end

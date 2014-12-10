require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.12.06.1/youtube-dl-2014.12.06.1.tar.gz"
  sha256 "5009555b95252864d0df151775529efeef041e1c7e49be8fbeee6eb459efdd1e"

  bottle do
    cellar :any
    sha1 "f15228fc2b11a657b0bf53776384567fbca8f4ab" => :yosemite
    sha1 "01ef160f6be62380e441e24dbfc4aca066c974e5" => :mavericks
    sha1 "852710df319b0c8dd20d628d039fcb11748eb6cc" => :mountain_lion
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

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.11.10/youtube-dl-2015.11.10.tar.gz"
  sha256 "c5a34ecbcf27ff34e1aae7c17732095309012e33ea9d1d4def613ca73f47e6be"

  bottle do
    cellar :any_skip_relocation
    sha256 "645bbfa8994e82d6db721129b0b36c0a6b4f6feb7e7ef29fffcc281c73939102" => :el_capitan
    sha256 "421bdf1c25870fabfe4b318d91a7b5f91f1d898a124ce5fc9b6bfb8f20f15990" => :yosemite
    sha256 "5cbec1e0400069b1ebb1636a82fd4e2a5d6ae2882d61871ad6da6ebfb858fe9d" => :mavericks
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
    fish_completion.install "youtube-dl.fish"
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end

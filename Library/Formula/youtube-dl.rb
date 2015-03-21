require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.03.18/youtube-dl-2015.03.18.tar.gz"
  sha256 "c32e864d1d61a703d7e37deaf0a34d9390e07e96a854dd338e44e654ab4aceef"

  bottle do
    cellar :any
    sha256 "f969c90d6f15a547fc96e9ca12802d224525ba04e72c42dd706525ca2d76581e" => :yosemite
    sha256 "65718384c78cdb24dda9fa13776f5311b3d0659377bf035060a0442985587391" => :mavericks
    sha256 "8d59d7206eb7468684c2e7938d500d3706527ef10ca9ed022e9a956a47280afd" => :mountain_lion
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

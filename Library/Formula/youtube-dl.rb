require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.05.03/youtube-dl-2015.05.03.tar.gz"
  sha256 "9736fbd7de909f99d75e7a828d4b2828ba7d08b174159e73f096a09f54a59d32"

  bottle do
    cellar :any
    sha256 "38e04507d733f20627e1df4c0cfcc513f077b8eea542729440e30c55e6c23af3" => :yosemite
    sha256 "a4d46506f5f60598f8de853af1ba63792eb2e7ccf307829687ebdd116782e262" => :mavericks
    sha256 "6d35f5e4ee5dc6f39cefea3f93f0db7e18b0827191ed603ec7a2d2885b2d446a" => :mountain_lion
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

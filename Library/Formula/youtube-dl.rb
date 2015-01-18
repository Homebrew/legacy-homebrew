require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.01.16/youtube-dl-2015.01.16.tar.gz"
  sha256 "194eeeea3357b95eb447d8cfdc3227802849e2be697e2bad925cfad01e3a673e"

  bottle do
    cellar :any
    sha1 "710022f2dcd6c3d0816e4d67c2ce6592bc17a50f" => :yosemite
    sha1 "b74d0130ca502c1f6191b272adaa05411c8f38f7" => :mavericks
    sha1 "97cb214cf850dde2c525e89eab90f37186bd3b83" => :mountain_lion
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

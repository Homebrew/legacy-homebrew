require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.12.14/youtube-dl-2014.12.14.tar.gz"
  sha256 "13e102f641b3714e8c80ac8909a44c8ef49bb3708728fa2495f34c6b4b795082"

  bottle do
    cellar :any
    sha1 "4cabe6f6acd6ed0ee823165b5fec13144598b146" => :yosemite
    sha1 "fe55bfdee29a5f0fab8b33e18d31174a6a06c4a0" => :mavericks
    sha1 "fda0f2a118f8bd48fc70c76f8f2306110b09524e" => :mountain_lion
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

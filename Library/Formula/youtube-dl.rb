require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.10.23/youtube-dl-2014.10.23.tar.gz"
  sha1 "827af926e850b0c7eb8dd245607e54e14b72d30b"

  bottle do
    cellar :any
    sha1 "4a7b22ae04c4d8e447cd0d83752e9ec677111866" => :yosemite
    sha1 "6bae7f6441d6c2a1958d21fea972f999f38d991a" => :mavericks
    sha1 "546cef86a7ffe1a91da4ea1ee27c55e706756ecd" => :mountain_lion
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

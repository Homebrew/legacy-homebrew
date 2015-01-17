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
    sha1 "14aefebc22705539a977065b737169f8520c04d3" => :yosemite
    sha1 "28e6d04040b3d611a3c7622fd360a8b638e000ab" => :mavericks
    sha1 "6195f68fdcd140305fd28e335fe831c47155060b" => :mountain_lion
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

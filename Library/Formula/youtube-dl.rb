require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.01.05.1/youtube-dl-2015.01.05.1.tar.gz"
  sha256 "67428cd5d0a34da00ede41ec1fd22cc9b6d3caf44586b02b69d4de810599564b"

  bottle do
    cellar :any
    sha1 "edbc6db5e4bebc0478d725f0d587a084ec98ade2" => :yosemite
    sha1 "9743173855bc7241bc37f35bddce0e73fec2592a" => :mavericks
    sha1 "13089e8cdca70d34397eca5c11840a6ca615a625" => :mountain_lion
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

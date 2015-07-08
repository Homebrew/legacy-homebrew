require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.07.07/youtube-dl-2015.07.07.tar.gz"
  sha256 "634d7a3c369a245e67317ddb4043f8167bce3e774e1246ecb7c2707d311c2b4e"

  bottle do
    cellar :any
    sha256 "fc4d9ff918d6f5158021a75e84246a1012ee061536f1a7053cba8f7c7b6a6321" => :yosemite
    sha256 "e46b79af5681bb8a011d17f7d45c323634a51d40054fa7d06a13a18eb4fb98ed" => :mavericks
    sha256 "1c5ea43f3aef3d622ab76eb61f82d8ba33acf04fa31d81a08b56bf21a4535d95" => :mountain_lion
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
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end

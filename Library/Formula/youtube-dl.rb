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
    sha256 "968f2c59df9c0ceca3138c2c5bba1335d94d004eb6b79b81d68d1be8c5d426d8" => :yosemite
    sha256 "74ad6435131b79c78c8cecb75aaf0003454ea716bd090820b9818cb6e40213c7" => :mavericks
    sha256 "e99732006abacb51d3fcb19845b314aca002ef4d6d9ac22223c5c208880092bb" => :mountain_lion
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

require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.01.03/youtube-dl-2015.01.03.tar.gz"
  sha256 "1c3c6dabe8672c13e7925f17493930889a34c556e229d7b69df56d1ded812b4d"

  bottle do
    cellar :any
    sha1 "9f5d288a10ed2f43260902a1b658579f986c1655" => :yosemite
    sha1 "2b3e5010ab35502593da094a333114482157cfdb" => :mavericks
    sha1 "ce3447db6845e0cc6d2bfd3c8ef3c256a9f53d97" => :mountain_lion
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

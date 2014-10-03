require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.10.02/youtube-dl-2014.10.02.tar.gz"
  sha1 "0d671e5dc3e4392057fddac18ee0fc1cc7b9b7d9"

  bottle do
    cellar :any
    sha1 "73569be5debb071ca16a43f43131bf700a45cc1f" => :mavericks
    sha1 "7556a5318bd194dbd780a29e17bf4b7ecad996c5" => :mountain_lion
    sha1 "475a5a2c040b7d9389d3e3411a9f469bc059273b" => :lion
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
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "http://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end

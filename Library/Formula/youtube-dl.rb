require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.04.30/youtube-dl-2014.04.30.tar.gz"
  sha1 "39ef1f38adeefaea3af17957c66a2aca05b4c747"

  bottle do
    cellar :any
    sha1 "283d43da7c2cc0d574dba9d9898862f0f8ebd2d1" => :mavericks
    sha1 "f0a0a24fd014766898cda0bfde2621ba86b56980" => :mountain_lion
    sha1 "123e323857f033584408dec4f39babaaff273f5e" => :lion
  end

  depends_on "rtmpdump" => :optional

  def install
    system "make", "youtube-dl", "PREFIX=#{prefix}"
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

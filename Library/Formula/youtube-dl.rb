require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.09.25/youtube-dl-2014.09.25.tar.gz"
  sha1 "b5d22e23d5525a418ed5cbb1c7f151baf16975d5"

  bottle do
    cellar :any
    sha1 "ccd53f776cfefd52b72b52a779b15ac5b6efe92f" => :mavericks
    sha1 "01262c3780b955b424ad9f94452a6fb8927c3e76" => :mountain_lion
    sha1 "17ba04d15925d8cc3fed689daa5802abb13819fc" => :lion
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

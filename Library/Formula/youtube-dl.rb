require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.08.29/youtube-dl-2014.08.29.tar.gz"
  sha1 "9f28a0f1ad389da6abb4e6d6af20a918eb504763"

  bottle do
    cellar :any
    revision 1
    sha1 "c6ce9e8961c59c712871491e4f032895d8d3d009" => :mavericks
    sha1 "0554937fa037d064a697de8451fc19eb28d2caf8" => :mountain_lion
    sha1 "b434bce27bf93777b7a3a649bae2e4202bc0cbf5" => :lion
  end

  head do
    url "https://github.com/rg3/youtube-dl.git"
    depends_on "pandoc" => :build
  end

  depends_on "rtmpdump" => :optional

  def install
    # Remove the legacy executable from the git repo
    rm "youtube-dl" if build.head?
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

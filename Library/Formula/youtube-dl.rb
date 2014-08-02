require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.08.02/youtube-dl-2014.08.02.tar.gz"
  sha1 "9dd0e8630ec543b17acdc2812a6899a7171d8741"

  bottle do
    cellar :any
    sha1 "860c65ea577791043d0a5398eb9b8477d48e9298" => :mavericks
    sha1 "be3894af50e17b15e593281508ae8b3e9523bb1e" => :mountain_lion
    sha1 "727a22e5cf33ad7955e4f6a14144f97e6e212d32" => :lion
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

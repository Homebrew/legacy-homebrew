require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.05.05/youtube-dl-2014.05.05.tar.gz"
  sha1 "e7740e21924b5314599a356f0e1729f9cee52450"

  bottle do
    cellar :any
    sha1 "d3ce5b953198493b3694dfa66e69d059993076d6" => :mavericks
    sha1 "02b06475594e6ee9a558efab7510f447df81517f" => :mountain_lion
    sha1 "0884083945b69aaabadc9ae11188a387f5a7f667" => :lion
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

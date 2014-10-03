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
    sha1 "44d54c1a0ee2811cd5d2f42e935af90899de872d" => :mavericks
    sha1 "fba1a023e6c33951da855a65fc7db2cf68735d63" => :mountain_lion
    sha1 "dab937cda4b2031d36d6728f9fcb81d037c13b18" => :lion
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

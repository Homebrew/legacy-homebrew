require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.09.19/youtube-dl-2014.09.19.tar.gz"
  sha1 "e176ae5744c60fd74fc6fc7949ee36caf5cb9f71"

  bottle do
    cellar :any
    sha1 "2609937556866d0065563ab33ad28f83c9b10fc9" => :mavericks
    sha1 "3a63b749e4c6da990b1fc7debd3d7867eb801ad7" => :mountain_lion
    sha1 "446f2ab125c3269a59a53bd10e1117db28b36e37" => :lion
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

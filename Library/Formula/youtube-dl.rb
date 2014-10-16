require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.10.15/youtube-dl-2014.10.15.tar.gz"
  sha1 "35050e7c9c7cffa1997395427d959648d07e11c7"

  bottle do
    cellar :any
    sha1 "301fe9a90d3e232e23aa446b11d0a8d5ccc1dda8" => :mavericks
    sha1 "bbb949bfb9503386016cf2bad9907bc6b970aa40" => :mountain_lion
    sha1 "98afce53eb99c4ad825230deddc0bcf8fb18efdc" => :lion
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

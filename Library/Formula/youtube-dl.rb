require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.08.05/youtube-dl-2014.08.05.tar.gz"
  sha1 "4af2cc3e5b08751861dff83315751213fe09baa0"

  bottle do
    cellar :any
    sha1 "32dc57748f79007569ec5f70afca73cfc27aacd0" => :mavericks
    sha1 "e84cc99a818d696c9b02b20082e67d73113f9497" => :mountain_lion
    sha1 "34fc123dc26f21dc33f92c5e1cedfb068153e866" => :lion
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

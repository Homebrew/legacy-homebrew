require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.06.25/youtube-dl-2014.06.25.tar.gz"
  sha1 "305905cbc9ed6a1579473cc8d38367c5dd13f611"

  bottle do
    cellar :any
    sha1 "353fc640c0344edf8ea8bb24d6f04235b954147b" => :mavericks
    sha1 "82669a3c807493a6d2453004242f327bbb995666" => :mountain_lion
    sha1 "2de796a8da88148995e8023b719e12ab5d902fd6" => :lion
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

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
    sha1 "f3abd53a4d81168b928b225c119e632858cba112" => :mavericks
    sha1 "b8c98397e782719c49a3715c9437794d72f7b93b" => :mountain_lion
    sha1 "76b5f07fc14e6274313a17a601216004591bfb59" => :lion
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

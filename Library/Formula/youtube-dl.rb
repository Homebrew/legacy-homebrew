require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.06.19/youtube-dl-2014.06.19.tar.gz"
  sha1 "34c2d31ff388a0b2e8905b40c2189596928ad761"

  bottle do
    cellar :any
    sha1 "280c5240bb49b025150602f190c488de8252af1f" => :mavericks
    sha1 "67be9cd9a0e4a2f2469f2ec12fbe021b15f9ab14" => :mountain_lion
    sha1 "8cd7b9185515b087b25d7cd2160a3f97c8ec4379" => :lion
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

require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.08.27.1/youtube-dl-2014.08.27.1.tar.gz"
  sha1 "aa036d38b6d6ccc061f87620c19ea8065fc20966"

  bottle do
    cellar :any
    sha1 "17859684a38b984248724096ed25bae6f2ec9a6b" => :mavericks
    sha1 "35b4c2b37e898d45061fbcb61fd157f464e1540a" => :mountain_lion
    sha1 "c650beeb74a5a6a7b4c6da3c0e6e2c23bc682f48" => :lion
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

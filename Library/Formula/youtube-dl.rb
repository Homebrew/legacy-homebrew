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
    sha1 "17243f812f85ffee6fc69171d06ea1dde5e2f441" => :mavericks
    sha1 "bc7b2645d60c8385d132dd9dd9b0c8eadd4dba47" => :mountain_lion
    sha1 "d9866bbe2f50e1348eacaca44f442905dcc9de4a" => :lion
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

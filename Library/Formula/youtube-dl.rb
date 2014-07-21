require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.07.20/youtube-dl-2014.07.20.tar.gz"
  sha1 "c40cfae0b4682eac7043ec7e2d238e1e6b034e10"

  bottle do
    cellar :any
    sha1 "bd01db1d0bcc3b66894bc2c5d153f86bc766f898" => :mavericks
    sha1 "7757a9d4d2e516618c21bf0851d704d450cbad1b" => :mountain_lion
    sha1 "54fc845906873844872945fb869394fe284e4ac7" => :lion
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

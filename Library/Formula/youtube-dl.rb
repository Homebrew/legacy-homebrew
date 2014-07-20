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
    sha1 "754fc148d5274446ad9a43e4ea99f96c4ee60d17" => :mavericks
    sha1 "bef1521f5f5f20808447add68d1adc02ef2b9c12" => :mountain_lion
    sha1 "213a060b3562d4cef9af5c13aab756615d98795d" => :lion
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

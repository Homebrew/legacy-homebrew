require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.05.31.4/youtube-dl-2014.05.31.4.tar.gz"
  sha1 "713dcf9b5916bd35e348ebb509a2661445eb6bb9"

  bottle do
    cellar :any
    sha1 "b4d46cb35e1def5b1d1387546e0e0b0613ef4e07" => :mavericks
    sha1 "3cf40ba1ff6619cdea4e062992e5edccd3f7eaa2" => :mountain_lion
    sha1 "dd26274166e03a674fc96b1cb37fb7023d119cda" => :lion
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

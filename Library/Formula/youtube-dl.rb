require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.05.16.1/youtube-dl-2014.05.16.1.tar.gz"
  sha1 "23e8c9cd63705adad9788100b71a5f94cc8a838d"

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

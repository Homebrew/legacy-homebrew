require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.09.04.3/youtube-dl-2014.09.04.3.tar.gz"
  sha1 "2dce554aa60d84b688580f3f357190ab86b8c247"

  bottle do
    cellar :any
    sha1 "b1cf66aad269dc27724e2276d60790a767cbf5b8" => :mavericks
    sha1 "5cd7482bde16eedd75e1cc6b2821bec2e99555a9" => :mountain_lion
    sha1 "db8a7ab408ba266e72660cdf2349e422e2c26a28" => :lion
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

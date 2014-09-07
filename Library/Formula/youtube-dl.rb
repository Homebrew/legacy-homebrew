require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.09.06/youtube-dl-2014.09.06.tar.gz"
  sha1 "606967a23023765098c6b1171c4ad5f246cbdbc5"

  bottle do
    cellar :any
    sha1 "88733e2c1aefe7842533bc557584995eb0a3f9ac" => :mavericks
    sha1 "a9f5dff11baed4ed2f8a7162c17330b5c89591a7" => :mountain_lion
    sha1 "3df5e9fd9806fec37e1fcee68bb637ce98aac65a" => :lion
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

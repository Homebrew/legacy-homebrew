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
    sha1 "1ffc93f4353e303ddce188f46c7d058f86151594" => :mavericks
    sha1 "cd69a2e4574a06e99b354bdf0d2d29caa09eb232" => :mountain_lion
    sha1 "5bea308ec8354b7864c1e45c96008e39b0e3b5e7" => :lion
  end

  depends_on "rtmpdump" => :optional

  def install
    system "make", "youtube-dl", "PREFIX=#{prefix}"
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

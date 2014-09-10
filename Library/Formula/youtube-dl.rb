require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.09.10/youtube-dl-2014.09.10.tar.gz"
  sha1 "b542736caccf807b465b60f47fd754bc6e9053fc"

  bottle do
    cellar :any
    sha1 "3f94ab6ca2bb0ae16477407311435c7f435cddbd" => :mavericks
    sha1 "cd3392e8c131b2f39ca31f1478fff3ca30659efc" => :mountain_lion
    sha1 "2e80fbb5b5158708e3a98f838a924ca32a8126cd" => :lion
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

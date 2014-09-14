require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.09.12/youtube-dl-2014.09.12.tar.gz"
  sha1 "9d90712e819bdfe1ca1a8c81582eb216d947b885"

  bottle do
    cellar :any
    sha1 "ea217f3bd98afc7e54b95ccef99aad63cef1ecaf" => :mavericks
    sha1 "ec833ccc8f93317fc602490d1ca46b65848e17dc" => :mountain_lion
    sha1 "69e0576d2fd587bd9527453ca4443943df352b4d" => :lion
  end

  head do
    url "https://github.com/rg3/youtube-dl.git"
    depends_on "pandoc" => :build
  end

  depends_on "rtmpdump" => :optional

  def install
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

require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.09.14.3/youtube-dl-2014.09.14.3.tar.gz"
  sha1 "d3e7b6c8c56f014a7f2337d49497fce73afa4692"

  bottle do
    cellar :any
    sha1 "f575409a9cfed8fd7b903c2f4d45877d995d02f1" => :mavericks
    sha1 "7bc722d6582b4cefd5634dfff20dffaf1b86787d" => :mountain_lion
    sha1 "5eb7d780b148834744059222f9c9551478085e8d" => :lion
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

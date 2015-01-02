require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.01.02/youtube-dl-2015.01.02.tar.gz"
  sha256 "68009779eec5dc31b98d4b5dc8dbbad3af22006f55cff3966e1b7a1c28866e2e"

  bottle do
    cellar :any
    sha1 "5520ec6ba9ddfb524a5c481147d8c8023a58c66e" => :yosemite
    sha1 "3dd627e167df5e8fe12e9462a88ba1ccc4ba0690" => :mavericks
    sha1 "f94988fccd860b11dac679337671d2c0d739bc7e" => :mountain_lion
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
    zsh_completion.install "youtube-dl.zsh" => "_youtube-dl"
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "http://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end

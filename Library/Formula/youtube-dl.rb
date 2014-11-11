require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.11.04/youtube-dl-2014.11.04.tar.gz"
  sha1 "36e1a256417b78f20d639fd6fa5727dfa2d5c6e7"

  bottle do
    cellar :any
    sha1 "9f3c1260194b2b7e39dcf71edd196893140d75cc" => :yosemite
    sha1 "bf82c8fabdf00954b85a19b2d83fdd77391aaf5c" => :mavericks
    sha1 "a8353d9dab4443fbb5cdb3b45c869c8fc17b0a1e" => :mountain_lion
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

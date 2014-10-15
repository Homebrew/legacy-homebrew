require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.10.15/youtube-dl-2014.10.15.tar.gz"
  sha1 "35050e7c9c7cffa1997395427d959648d07e11c7"

  bottle do
    cellar :any
    sha1 "495e2453ea81b4d0583160f814fd6cf98809fb6b" => :mavericks
    sha1 "a59966db387bbf23dbc8bd441e3321991247f368" => :mountain_lion
    sha1 "5e4a23697d3485552612b9267f05dfa157412dea" => :lion
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

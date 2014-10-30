require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.10.30/youtube-dl-2014.10.30.tar.gz"
  sha1 "544eed95306a7e747f39df186cfa66bc0f763a7e"

  bottle do
    cellar :any
    sha1 "8fcc6bbca4f9d3879ad24c4e9139f1a9432cc457" => :yosemite
    sha1 "d710efb252278d0d75625a7b5a7f64f2ddfcedd1" => :mavericks
    sha1 "dc739cd3775a15bdf217ee65d33cd39b0eb1fa17" => :mountain_lion
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

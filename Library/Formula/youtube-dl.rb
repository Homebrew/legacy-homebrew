require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.02.16/youtube-dl-2015.02.16.tar.gz"
  sha256 "1dab1a3184197ee2e1c3ce0a06fd6aae3af06dd6e42f6f3e2eb3acb457106350"

  bottle do
    cellar :any
    sha1 "ecb3a1c6d607c7925a7c815409ef2a9e088f74e4" => :yosemite
    sha1 "faa48768c8a26d5019888fd6e54c58dd5467e747" => :mavericks
    sha1 "e934bac686037fe83f5f0d400ca9364d708acb9f" => :mountain_lion
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
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "http://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end

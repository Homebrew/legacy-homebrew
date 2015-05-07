require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.05.04/youtube-dl-2015.05.04.tar.gz"
  sha256 "3ebafe6257bfd8a9feb1e16f44c92258b038de07e8754560f05bd9909f9e113b"

  bottle do
    cellar :any
    sha256 "b8cddbf6b365815ef49059af92c9a838c2258c9ec82b8fefad6dbb2c09477c1b" => :yosemite
    sha256 "bbeaa365da84f7071fc85f9238091a0d4dcc3281e8525f2ffbd7bef919b8ffd0" => :mavericks
    sha256 "a9bdc5fa7beaa1bb9e79857641b9d202ce2fec6b2716e79d5a2b9b55bb381e44" => :mountain_lion
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
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end

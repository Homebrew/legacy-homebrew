require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.02.04/youtube-dl-2015.02.04.tar.gz"
  sha256 "b2d147e251f997c84bad92277ebdbc44f6aa7bd62b7def9e55ffdb1c3e103264"

  bottle do
    cellar :any
    sha1 "528f21a56e2ad23718ac96f71411dd7f1b2f0b26" => :yosemite
    sha1 "5252899595c1b3e6f1c5527e34f4593d16602118" => :mavericks
    sha1 "2c86a2c2f8d67a8bec7dd5202723d579d2d81a9d" => :mountain_lion
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

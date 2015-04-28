require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.04.28/youtube-dl-2015.04.28.tar.gz"
  sha256 "08748955f1a511d1c118d4241cc8380237383afb76ce5e547d73fedd5aee968f"

  bottle do
    cellar :any
    sha256 "956d4855241a2642aab8929622672e9c191631ca655c9683ae7d13343ad908c1" => :yosemite
    sha256 "86cecfef2eef34792680c1263a5de24a0d1a53b3e3e92f3c1f9792ec38ece15c" => :mavericks
    sha256 "911429409e585790fdbe3dbea836a6d9dd077c3444d636cc7d80877574895757" => :mountain_lion
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

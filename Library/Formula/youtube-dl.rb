require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.02.26.2/youtube-dl-2015.02.26.2.tar.gz"
  sha256 "a00e9f8e040c7cfa4a3d53075386a4d8bb8c1fc7e66ca40a1edf95377f8c417b"

  bottle do
    cellar :any
    sha1 "9cb845364f840ac1e1ec55945f9f7a2e568a7d11" => :yosemite
    sha1 "c3e38972f687486ba93df0f03828dad01c7dcf99" => :mavericks
    sha1 "7cd336062fc91a21dad11e9c9c4131d3fe4c0877" => :mountain_lion
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

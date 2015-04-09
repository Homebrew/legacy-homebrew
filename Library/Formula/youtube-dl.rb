require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.04.09/youtube-dl-2015.04.09.tar.gz"
  sha256 "8171182490e33413ad9f21c2f46b6640c8baee7655c95d4bf96ae696f3ce1c6c"

  bottle do
    cellar :any
    sha256 "4b19d4aa41c60685d0f2a9539e685309583e3f9563d11c63e0b1bc33c3c971b4" => :yosemite
    sha256 "1a904b5d6bcf1cd8cbc91da79fcca984dd4e0a46222bd509c26e593dbe9de08c" => :mavericks
    sha256 "ec3ec597e97769e3df9786bca36185e591386e24a4ab6e5fe0280a44d2c3a40b" => :mountain_lion
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

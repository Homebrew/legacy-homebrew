require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.12.04.2/youtube-dl-2014.12.04.2.tar.gz"
  sha256 "a26b68ff9a208d0b5edc6cc5109260215d713877a015725fdf04d7a2c639d9fd"

  bottle do
    cellar :any
    sha1 "97a2d016f1c23063c552245e9aea01247b7677dc" => :yosemite
    sha1 "ac60af167fe473608e76bb103e53041957cd0370" => :mavericks
    sha1 "a5a9708c620685f3210776a5fa6e3bc32bb37f87" => :mountain_lion
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

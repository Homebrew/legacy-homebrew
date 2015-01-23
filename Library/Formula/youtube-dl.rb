require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.01.23.3/youtube-dl-2015.01.23.3.tar.gz"
  sha256 "0f8bcc7b5ef11e219f0645423f9f1be0f0c3c2b15ed6b36b6f9cca240775f633"

  bottle do
    cellar :any
    sha1 "053ccccba1bfc57129e7ff46f8415481af577782" => :yosemite
    sha1 "2d92cbbe731f45d1a8147508627b571291784943" => :mavericks
    sha1 "15a58f5f6be57e3d244402c4f50d79c12a25eea3" => :mountain_lion
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

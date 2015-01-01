require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.01.01/youtube-dl-2015.01.01.tar.gz"
  sha256 "a6fb876a03c4fb3e9da21ef23534a53a2bf7981c3f0fc8cc7fe07522e799ce12"

  bottle do
    cellar :any
    sha1 "3e56e8406c30d9ec653239a743238037a69f707f" => :yosemite
    sha1 "840c2caa92233f496c32779c1272a6b7c66c9bd0" => :mavericks
    sha1 "9d3010bdb29721b3dcf6b011c2a5842678d9265a" => :mountain_lion
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

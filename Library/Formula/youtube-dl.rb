require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.12.03/youtube-dl-2014.12.03.tar.gz"
  sha256 "019414111094a3a1e52a14fe579fe1a52dd5a60eb19170fb6fc159aa5e1b1908"

  bottle do
    cellar :any
    sha1 "68d76ad4789814dd19854fb7a7e38f136484acaf" => :yosemite
    sha1 "b52c168b36ef01e7426727e3b762741bae7ed8f4" => :mavericks
    sha1 "390405ccfcf10aefb1b9bb387175ce8334af3588" => :mountain_lion
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

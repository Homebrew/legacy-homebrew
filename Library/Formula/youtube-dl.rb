require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.07.21/youtube-dl-2015.07.21.tar.gz"
  sha256 "0b4276ce0df1add4081ca01b5d9460ce8ac6b218fb29ec6b4ddc7130a9ff29d9"

  bottle do
    cellar :any
    sha256 "b11fdfd73a797259014f47e44edfa6106f63618e25d669ca16362d5c71ab42aa" => :yosemite
    sha256 "36f027fc31503b2c18bc04fca391ea36519d47668902d4a45d637079054f2687" => :mavericks
    sha256 "96bd94017eb80d67e4edd687dbba634df480037780dfde92ed7e4700ea27a305" => :mountain_lion
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
    fish_completion.install "youtube-dl.fish"
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end

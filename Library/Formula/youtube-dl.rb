require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.01.30.2/youtube-dl-2015.01.30.2.tar.gz"
  sha256 "95268ab14425c5ab1d13b338400d9611f0b06d64812c7ed44c2c3e4c8ae8d503"

  bottle do
    cellar :any
    sha1 "1bb153e8937b9db3f522e77dabd901c06d7d99b3" => :yosemite
    sha1 "9d3d303a025263ff254ab5d04e8f313b8cde0068" => :mavericks
    sha1 "369dafec6524c79744e8e72e1c5fd00d8eb30b02" => :mountain_lion
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

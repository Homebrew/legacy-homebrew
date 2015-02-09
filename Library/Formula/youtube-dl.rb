require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.02.09.2/youtube-dl-2015.02.09.2.tar.gz"
  sha256 "532b28e354bc2408b5e08cb582c69e1ce2dec0a9cf1f3efa55571532a637b362"

  bottle do
    cellar :any
    sha1 "9664679d961c1880a1f4c8ecc6d847a705cd38ae" => :yosemite
    sha1 "84bc8518cc910b97020982e99f138ae03e875182" => :mavericks
    sha1 "0cf51d361a33ad7c3cc476da748191e5d7eb9f95" => :mountain_lion
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

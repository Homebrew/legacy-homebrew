# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.08.16/youtube-dl-2015.08.16.tar.gz"
  sha256 "85ef29e55989bdde8ea1bf9084484288e2acf91bf9c9d2f6ee08380d427712e6"

  bottle do
    cellar :any
    sha256 "1b9a7846144f97a91ea479f30822ac9965d2c13616da53314f68bb3553d87ec6" => :yosemite
    sha256 "3fdcb868e6cc9b694a4c736fa7ac0f8a3971b001412bfb00e6b7ecb444b1c562" => :mavericks
    sha256 "2d001415e971c58eab5d1024b4340d0dbb217a9489fcf9cb298a85516f921a99" => :mountain_lion
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

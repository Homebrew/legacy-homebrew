# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.07.28/youtube-dl-2015.07.28.tar.gz"
  sha256 "61c3acea56cb6127c092fed37ce77c64f14b501faceab54496412d3479685c56"

  bottle do
    cellar :any
    sha256 "62920ce3358ac039831c48ad0ca02e79d9097d8bbdefe9eda8125be8c0a1cc43" => :yosemite
    sha256 "1143e150b11d92eff735bcb8d308ec51c01acf48c6bc5eb30e13fce052fed8bb" => :mavericks
    sha256 "085254b48803b798641f703e26d667136383dcb85511612a56c92596a3267047" => :mountain_lion
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

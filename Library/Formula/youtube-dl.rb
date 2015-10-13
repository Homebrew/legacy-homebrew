# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.10.13/youtube-dl-2015.10.13.tar.gz"
  sha256 "4588f98ecd082ac4d1574c6bbc386eaf625fe1b2b321f4f84a2eb6bea45b41f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "791ee1ccd383f606553f96afac0a08a297e8e3522c67a2fd32a27e9ee86e1cd6" => :el_capitan
    sha256 "cca9de1e43ea04a291badb109c97eb2092df48bf2b3c30307c806e98b6c9e531" => :yosemite
    sha256 "886a5ef49c2acff0813758d7985f6c917d6117fff9301783149f3aba2146e30c" => :mavericks
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

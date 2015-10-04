# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.09.28/youtube-dl-2015.09.28.tar.gz"
  sha256 "6396ee3150f51bd6ca2717b7d09f9524fbab22c04c3d2b560b99061d92127a60"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0884bdf05af0d958ed14ab5681a02f74b15615d4a5f55f90e1bc81458316fab" => :el_capitan
    sha256 "6851270f82aba4c5530085f4504c8ab5b3643a204fb20aefb9bf65a7c6472567" => :yosemite
    sha256 "15cc16bb9b7d4f81f205f22c9999c891ef3202645334baca2ffa290cce48ff3b" => :mavericks
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

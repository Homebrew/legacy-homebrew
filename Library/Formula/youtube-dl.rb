# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.01.15/youtube-dl-2016.01.15.tar.gz"
  sha256 "c1e22ca3286aff74a668d1f8ef5c84c37bee2c269824e71ffdb23356a8735c44"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e68f80d73e545e66f7c0cc6c88b67add9d34ef66b9070a26a731005b81ee438" => :el_capitan
    sha256 "1c77aa67ef7a0ed1d736d628b56048a42cfea38d5751fc190e971d50c069795c" => :yosemite
    sha256 "8f7ddb3c36aee3fc72a7c8a8f0b548331906635564dfed3d8f33e4cb3596abac" => :mavericks
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
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=AEhULv4ruL4&list=PLZdCLR02grLrl5ie970A24kvti21hGiOf"
  end
end

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
    sha256 "22b18b41474c5dae440318c550edba2112dd16028268c8eda969ae15b1aa6296" => :el_capitan
    sha256 "f990e01deda8118a01360018d95b1378d860daac38c18be6c6e9d97a73086e53" => :yosemite
    sha256 "a5b1ee2dcfeb670c4ecd151d2d7ab8c4058710012f9cb5a03277e5a69fde8204" => :mavericks
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

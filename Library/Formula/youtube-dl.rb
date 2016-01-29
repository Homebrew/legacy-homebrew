# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.01.29/youtube-dl-2016.01.29.tar.gz"
  sha256 "4b39800787d288c5f44cf00342d900d53386ef41c66a5397b406acac9fd60212"

  bottle do
    cellar :any_skip_relocation
    sha256 "814d28ac2ffe3b96f50fc485e37f37a27e35cbbf118f7b2d11da20b41089a182" => :el_capitan
    sha256 "364230d7cd4dda509b338de5544e5a2590e7f95276468fc9c68792b41aa005e9" => :yosemite
    sha256 "8f292ccfe26cb81b7e6d7ce13d495ad97ecb42f4e7426faa4760dfeb701b815b" => :mavericks
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

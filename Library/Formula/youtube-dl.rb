# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.12.31/youtube-dl-2015.12.31.tar.gz"
  sha256 "a56eaef77559402dba3ad7ea4da31b8cc77efcd6b10cbe50d8883732065269fe"

  bottle do
    cellar :any_skip_relocation
    sha256 "385c5793230d11a0592822090b40c75f36d142ab53f279e3efaffb3595de098a" => :el_capitan
    sha256 "f6e4c25b22d5ed3b8af2ebfddabb5af4933b2bf3301cc4c95ff0119a44b3692a" => :yosemite
    sha256 "e1cbb845bf080be8e94ca816d637a10c0703a4d52bfa9dea763fcf2eb20d7068" => :mavericks
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

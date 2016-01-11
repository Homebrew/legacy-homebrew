# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.01.09/youtube-dl-2016.01.09.tar.gz"
  sha256 "463cfed59a1e2c6609a8e3d3354e0494833f1b249fe1979984b06a51ac5c904d"

  bottle do
    cellar :any_skip_relocation
    sha256 "21790f03f7d89c2c0a7298457aeddbcd6fde0ded32252f8c127055ab24843bfd" => :el_capitan
    sha256 "6b3168515107b019a81b0e4dfe035f6e261d17716dd002b5174497df606c370b" => :yosemite
    sha256 "33a5ed93f3640b76bdb673525b4e9b06b221bdc660674a0b11c6824f61fd6046" => :mavericks
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

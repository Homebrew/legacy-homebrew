# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.03.27/youtube-dl-2016.03.27.tar.gz"
  sha256 "472e5d0b5907ace17267974ca8f3548c02c44c6ff679ab10ee01987873285dbf"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc76862f6058e4c1853e9047e20604a904b7c6566931ddb8b5b68f34fef535e5" => :el_capitan
    sha256 "bcfb02d9a9f678beb7fe14da96ce1d6ee86997718d48bf9cdaa2c7c7a9869dfc" => :yosemite
    sha256 "69672d61b32a78830764951b9337c1524839f0841d25b3b9338e03e001a99235" => :mavericks
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

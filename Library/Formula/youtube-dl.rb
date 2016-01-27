# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.01.27/youtube-dl-2016.01.27.tar.gz"
  sha256 "d06bb62ea19aef3ebb842ac01d98bbeee378e06d9e7c7a2f3bef343205b52ee9"

  bottle do
    cellar :any_skip_relocation
    sha256 "b87e8f9682e13944f77c2e9d86935ece04253e6b5409ea41d5b2023b0e4c8d20" => :el_capitan
    sha256 "5cb951361721211bcb4921846876b32a783292eb42d5cbeee65608007069ece0" => :yosemite
    sha256 "0c36281060107d56b50615922beeebc5122f76f647dec4d50947cc52b896999f" => :mavericks
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

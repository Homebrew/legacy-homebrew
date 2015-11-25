# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.11.21/youtube-dl-2015.11.21.tar.gz"
  sha256 "26ef30392579289ff54c54c6747fd0036a5fdf7429c55106f9703b0f9f19e339"

  bottle do
    cellar :any_skip_relocation
    sha256 "2216a578a7b604e7f0487a433a813f32b474c8ddb8a2bef1cbe67d11669c80e8" => :el_capitan
    sha256 "93394c9951ac1bb173e1fece2790c00173ddff380b8da56d5bd01d97cfad60de" => :yosemite
    sha256 "f1a87c27dd78053100569282f03ea3db29467614d116d80e157e5471451850fc" => :mavericks
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

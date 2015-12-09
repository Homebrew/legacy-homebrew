# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.12.06/youtube-dl-2015.12.06.tar.gz"
  sha256 "130be9fe481ce17a8d716e58324c837179099c5bb0789194e8e51b79b7c7b279"

  bottle do
    cellar :any_skip_relocation
    sha256 "d17a547da37ef712f98ee9036d7cf818f421753b36483a33b79773c56fc8b87a" => :el_capitan
    sha256 "2ee2fbf00068bcee9309781cc37944407cc7648a3a5a444ff5f10cd5a18d4c30" => :yosemite
    sha256 "e00500a912570c334b9ba00b2cd7c1314c674f0cfa35ef5fcd66863823d8f1c1" => :mavericks
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

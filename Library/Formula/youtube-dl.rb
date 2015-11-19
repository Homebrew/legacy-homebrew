# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.11.19/youtube-dl-2015.11.19.tar.gz"
  sha256 "2ed713c995a5cd837205eefa35d5df49179fa90cf634a4f222a31f2bde94e668"

  bottle do
    cellar :any_skip_relocation
    sha256 "02bf0716ec65e96609cff5f58dd9af22d6cd2dc2f30064a913d9e74d9a24d00f" => :el_capitan
    sha256 "6f18e05753e7dad4c773cc0bc3ff9365faa6a0b2168aab08c22e54c9d27dbef0" => :yosemite
    sha256 "f5ecb133fd8bbfd5bd2003ad5b090964ae589f2d2c6c079562786af32138d6db" => :mavericks
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

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.01.01/youtube-dl-2016.01.01.tar.gz"
  sha256 "732f37c99d71b4239d72d61dd32214b5a5a618671fb0629c8f8deb28209a172c"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a5113db1e580da0915a577a7c4a748312a5401428326f06b951b541e0099ae3" => :el_capitan
    sha256 "3859cbc8294cd818c6ea70ae6bcb1a566a3379d107dd8111b0e7cf7bf5000b0a" => :yosemite
    sha256 "0aa4889d8707a85753b5b51e1beb5dcb2ad7537005b8a509f232bbd4c14b1a90" => :mavericks
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

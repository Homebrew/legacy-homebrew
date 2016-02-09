# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.02.09.1/youtube-dl-2016.02.09.1.tar.gz"
  sha256 "f4811f2864e5ffeb8865c097c6373d1c487ef326df71d45accd5ba0ab01f3f78"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a6014d9afa484defda0c500f00b7d92b01c39f18ad677cf890095ac5e3cb5b9" => :el_capitan
    sha256 "9b1e409bad4da15372e20e19189c4d4fd23bf908ce67146aec36086b5f6f86f7" => :yosemite
    sha256 "13e4cd79d03f8fdfcaaf6dc2d7287303ce4a7e4cae6986c4d912c6ea44350ab0" => :mavericks
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

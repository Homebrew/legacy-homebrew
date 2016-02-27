# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.02.27/youtube-dl-2016.02.27.tar.gz"
  sha256 "fe22ed108ec94f35e66b0907edffc6e67af54ead95a6f71e4b1ac53d2e1e006e"

  bottle do
    cellar :any_skip_relocation
    sha256 "35702074faa3ea4f9d0d809aa2c7b5d5fcc21d994a9613c35aeeffe969869eda" => :el_capitan
    sha256 "7f45015f8431b7aba9eb2ba0e9b731cc5790d5dbb58aef9048457ee50b3eee3f" => :yosemite
    sha256 "c25bad90ef5e960c2ff27052cdaf714a544d001349235d5a0778efb854d7d5fb" => :mavericks
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

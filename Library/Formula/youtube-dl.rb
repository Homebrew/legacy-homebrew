# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.11.18/youtube-dl-2015.11.18.tar.gz"
  sha256 "ebc92ae887d2ff63c8091cdf7f6853d866acb39275f742ccca2352c5faf11235"

  bottle do
    cellar :any_skip_relocation
    sha256 "85ae1d207ac40c657995e73997b164851938276dcd6eaafe5e83effd12b40738" => :el_capitan
    sha256 "455be51fd7b88bb6288cf1de7a8eb64082c257649bec1fd484183eafad971016" => :yosemite
    sha256 "47b06d3b96ae534578202ed358fc717cfe64062fd30c026d9f7878e44b3eaea0" => :mavericks
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

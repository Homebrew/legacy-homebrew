# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.03.26/youtube-dl-2016.03.26.tar.gz"
  sha256 "7a5ef31c40c4e5b3d5a22e99437bf02b0c79b6a19e765749db6c9b754836bc61"

  bottle do
    cellar :any_skip_relocation
    sha256 "4caf279a36d35a254d1053a209ec6256bde9cc86d0be074994aa3559994da5c5" => :el_capitan
    sha256 "f73450021310b5c695f628c018c3737836172813191583601da8ba190d747d99" => :yosemite
    sha256 "56d3348e581dc31c55319c759f2e587b2c2487c2c9b3830fc782a29bbab3efe7" => :mavericks
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

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.11.24/youtube-dl-2015.11.24.tar.gz"
  sha256 "cceeb606e723c0291de85eecb9a551ca887f3be4db786ad621011a9201a482b1"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd998011dd3685ee1677b7f6befb81af955278acfd32524b39dd0d05f15efba6" => :el_capitan
    sha256 "3da4de2c644ba171f28a58311eaaf01686cc1fae0fc1625dcdd9521e85b47fc7" => :yosemite
    sha256 "0858ffc667a35f8147cf02e8f705d3750f640cb3ed953ad041176c821ff8b70e" => :mavericks
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

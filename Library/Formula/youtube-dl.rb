# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.03.18/youtube-dl-2016.03.18.tar.gz"
  sha256 "1322afa755bc84531d1ede700a5fa2a6abb815b13a9382b83b78c5193f56fb8a"

  bottle do
    cellar :any_skip_relocation
    sha256 "dad29aea983fc3e41ffc7f14d928ce07b391fd45144efe3fda3372d429eec54e" => :el_capitan
    sha256 "d2018f61967e5fd12f68eadd79967437d534f4ed02a519d2805f6ef351f6ccb4" => :yosemite
    sha256 "57732e4bda6e2fa28bcaeeb52e6669cb15612f893999926053a4a6897d84ea8a" => :mavericks
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

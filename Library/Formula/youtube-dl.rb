# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.11.02/youtube-dl-2015.11.02.tar.gz"
  sha256 "5c5bc5a7fec405ed353bd7052a4a83e8782742d246b24af73393fe70c7b28d8c"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b2307f8899c97de92264f0e1702e036dc72de79a742ab570ba1ddd7485dced1" => :el_capitan
    sha256 "d18cc08f636c74770ee07cca73b70bf47c998ccc9ff6506cb55d41e65f460018" => :yosemite
    sha256 "60471be54d4b351593513c65d76f1f6416f15ed2b0ef7786b08be1da1f09d9dd" => :mavericks
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
  end
end

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.11.13/youtube-dl-2015.11.13.tar.gz"
  sha256 "dd75b284de30aeff6b85d8550ad19cb8ca481961eb762304b6576ffeb8022408"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a59407aef62b33c78a166dc9fb898464de4fd720df352201da02d34184ead3b" => :el_capitan
    sha256 "3d272cb643bc50183d8a5a178730d796d0b0dde827022e3ea42d7a9cef1728b3" => :yosemite
    sha256 "76d15624b2374519c29ec614daa69e06a12fbca272aa5b8d30c71768fde35535" => :mavericks
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

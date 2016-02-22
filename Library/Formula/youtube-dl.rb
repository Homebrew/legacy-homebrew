# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.02.22/youtube-dl-2016.02.22.tar.gz"
  sha256 "14cf17af94a23d451c1c8d2fcc8ee072ee99746d6bc7487c91043498599d630a"

  bottle do
    cellar :any_skip_relocation
    sha256 "752ff3a82078b1ed368dcdec2d30c13ec8e69b97f105644abed4155bb4942339" => :el_capitan
    sha256 "1c030e1b9cb4f01cca2da9055b819cf2e6ed980008dbb019bca92bb8e071719e" => :yosemite
    sha256 "94467556069e66d3d3831b1a6c54f88328dcfe0f739f67738e4a54bdb8a868a5" => :mavericks
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

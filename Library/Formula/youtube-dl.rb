# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.10.24/youtube-dl-2015.10.24.tar.gz"
  sha256 "fa151e925b51f6b5ee154f25089d287832a9387e59561810fd5eac8d00ce3ae1"

  bottle do
    cellar :any_skip_relocation
    sha256 "5affa49bbcb9105d3a0a08b8211b0f9eadba375e1d1398b0a2369dc21b4c53dc" => :el_capitan
    sha256 "8b5cea4eb4d3baf41373526a88df2e3d4070ecdc1d3e36a6d725e844c3533a1a" => :yosemite
    sha256 "997a45de7f4fd70aa73393d3d555a4e39f8419cbc6a4dabdcc11516f9c753a05" => :mavericks
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

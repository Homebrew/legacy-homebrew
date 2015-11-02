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
    sha256 "b8ba6d6e912411b81f0ca48a2f910b5db20afec66786c5067a8c0b885c4679e7" => :el_capitan
    sha256 "bb3243c9776cd3540bce5dc683aff8907d4921b905876ed5ac4066ea998c7b10" => :yosemite
    sha256 "fc83f62b1cbacc40ecf7b77859770c19ddcb4280b7cf2e14028df641f450908f" => :mavericks
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

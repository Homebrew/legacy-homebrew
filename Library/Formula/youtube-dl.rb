# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.10.09/youtube-dl-2015.10.09.tar.gz"
  sha256 "33103a3197ee1bfa5e9fa78449ed19de888d6b36cc27f46f5c2e76ea11aee0ab"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f30575268d7b25be22fe360a19b46dd7b85b087c92b40badf8db7bfc522c3b1" => :el_capitan
    sha256 "febb0fe72e58894835e92d3a5447bfb05366a786a50f153e4533d16cdb3577d0" => :yosemite
    sha256 "0c762d81679086667be6d04a9fce5f61930ee03482d363fdcfffe5ae8553c565" => :mavericks
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

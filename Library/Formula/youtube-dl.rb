require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.06.04.1/youtube-dl-2015.06.04.1.tar.gz"
  sha256 "cffb1edb9637962e6a2ea1d26284f52aa53c7f5cd2a3e1e94a21f414aa606566"

  bottle do
    cellar :any
    sha256 "ff784bcec0a0e2cac1738943cb9c3f418151a66178debc86202d67db04fc0f24" => :yosemite
    sha256 "dae30ecc83f13977af47e317867e023b271268f7b20b7a82c8b02ab71df10c0a" => :mavericks
    sha256 "d987424f12479fc44f744c83685d3760a7c91c787fdcb31498576837ae9c5744" => :mountain_lion
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
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end

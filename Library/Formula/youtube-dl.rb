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
    sha256 "a9fcd61a253faecef01bc256188e0e0eac1d3fbc2719821e3be9a741e6604e11" => :yosemite
    sha256 "5b105da4645411712d2ab15b9ed6e41695f87ed6d2afb0e87a3193d0595e3fda" => :mavericks
    sha256 "da42f9982845e5c9265121d3bbc6384d326136665f445d43571fe3842b04bfdd" => :mountain_lion
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

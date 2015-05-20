require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.05.15/youtube-dl-2015.05.15.tar.gz"
  sha256 "e64bdefd46f5c0172c4d43efebb6675796933362abf9add00fb071eb1eb58e2c"

  bottle do
    cellar :any
    sha256 "170bf48a51df92c416ede438871ed31a0663f4ff8c2a8d85f3dff3d1fa291b1a" => :yosemite
    sha256 "19130d59bb9db5eaac895299f65b9bc9fc24b66c5fa87a0d34c68e587c888585" => :mavericks
    sha256 "d69876e41c92c997095da19e6badee8b0f1b761cc042c14eb046e53b6e44f41a" => :mountain_lion
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

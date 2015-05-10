require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.05.10/youtube-dl-2015.05.10.tar.gz"
  sha256 "702558c33eee0d0ea896514b5b00f4fce8f61610294e07f150682ed7bdfe2d5c"

  bottle do
    cellar :any
    sha256 "e1e531b973517501f82fca484b82016eea33b9fa8d9e3c3a0e60ddfa9cd1e476" => :yosemite
    sha256 "41d1399ad5c675d08c99c660a7c68b97b491c763597728ec61ce87a63678e9c0" => :mavericks
    sha256 "c1c945340dab02f3c82b35c6c6b641cc97fdfb8275c3c2f080a5a4c3d438adf8" => :mountain_lion
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

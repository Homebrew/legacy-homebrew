require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.01.22/youtube-dl-2015.01.22.tar.gz"
  sha256 "9ff6b6e3d2b86043700f770f6a27acf8caa251f694f34227df8b27f67664f973"

  bottle do
    cellar :any
    sha1 "4c4c28ae60cd43650963fc306ae85cdccfcccfe5" => :yosemite
    sha1 "54715e97328c9c5bc063acff255060cf47b44ef3" => :mavericks
    sha1 "ab2e5fd9881fbb716253253d5a95fae937b5b7b8" => :mountain_lion
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
    "To use post-processing options, `brew install ffmpeg`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "http://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end

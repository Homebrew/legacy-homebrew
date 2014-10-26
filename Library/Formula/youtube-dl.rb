require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.10.26/youtube-dl-2014.10.26.tar.gz"
  sha1 "c5b315c09ec236eed6e68bc767fe10c1b4753a11"

  bottle do
    cellar :any
    sha1 "0d070cfa67438ce9cdb98f983367f05a41c1fbfa" => :yosemite
    sha1 "1ff2b8deed1190e7738957432539e39e596be903" => :mavericks
    sha1 "e65702883fcab9163759e2fdc786d13d5e8fc290" => :mountain_lion
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

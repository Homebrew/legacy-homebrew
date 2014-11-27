require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.11.26/youtube-dl-2014.11.26.tar.gz"
  sha256 "94cb86603d7a96f9331ed5db09d6adc6842d1729d0f1c8c6461018516b578aa4"

  bottle do
    cellar :any
    sha1 "355236018e07b9065fd8e3a3876a6fe1aa182d14" => :yosemite
    sha1 "f9874c9faf950d67cae810928d94509194ad0dce" => :mavericks
    sha1 "af6c9fc3a2d2e96b43bf5b32c1c0b6de6949ed92" => :mountain_lion
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

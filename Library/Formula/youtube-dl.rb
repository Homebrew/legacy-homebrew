require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.12.01/youtube-dl-2014.12.01.tar.gz"
  sha256 "e47cab932c1c1fcaddb8e4a3ada0560421f8d356d63c074b0a7e91b494a0ec56"

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

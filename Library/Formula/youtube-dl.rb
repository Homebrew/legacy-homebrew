require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.02.03.1/youtube-dl-2015.02.03.1.tar.gz"
  sha256 "63335405ccd2c2b9718faa5b929275d1c7dad528350cd4e6be24dc27173c14fd"

  bottle do
    cellar :any
    sha1 "230506fdef6ba98978ebf7a949cb199c69e59621" => :yosemite
    sha1 "1d2dde2f929328cc641fe01bbb4ca06a95cf4091" => :mavericks
    sha1 "dde15b7d0674f14368f851ec982f21b850e64e77" => :mountain_lion
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
    system "#{bin}/youtube-dl", "--simulate", "http://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end

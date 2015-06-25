require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.06.25/youtube-dl-2015.06.25.tar.gz"
  sha256 "6e64f50ba8e74e11318be19c72be56bdcf00673841ea77716a10967e04c48628"

  bottle do
    cellar :any
    sha256 "bd25eb89c3d31f7123d6b89cb87004aa3836340bd16690aa06ab484468cede6a" => :yosemite
    sha256 "c139850ba1632eb79d0f4cc575f00268c2a4753edab0b76c1b8c6321bc4c74d9" => :mavericks
    sha256 "b7e91faae228468f7a91633b8bb2b9e1637389baf62f9afff4483c46e6ea19f7" => :mountain_lion
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

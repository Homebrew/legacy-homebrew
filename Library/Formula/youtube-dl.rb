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
    sha256 "186069f57ae2d66ef27e5bf19180f9c52c8c5c2efc5f112b3839881edeb5c95b" => :yosemite
    sha256 "4f59dd35d4d0c7b16fc758c1e795da8920fa61a15a452f26f314cac97dfcf282" => :mavericks
    sha256 "01a497182331bc99803b2bd58aa9bad22ce3cfafeae03b4823db4bdce1bc19c5" => :mountain_lion
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

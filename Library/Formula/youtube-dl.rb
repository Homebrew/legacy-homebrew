require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.02.09.3/youtube-dl-2015.02.09.3.tar.gz"
  sha256 "10a4bb45876697e3779d481ce8edb0cca4364fd38f6881712415719bca9ffde3"

  bottle do
    cellar :any
    sha1 "3c0709fc7e039113b00bf82f23cf34713ef0457a" => :yosemite
    sha1 "d06ed58fc77cb8fa9a0581b5b108dbea40ce1163" => :mavericks
    sha1 "975df29f9e0901b6e74c272854f7b2412a98c347" => :mountain_lion
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

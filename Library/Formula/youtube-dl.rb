require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.05.20/youtube-dl-2015.05.20.tar.gz"
  sha256 "94de6dfdca5fd2c2cf83961b204970cc98aa9c3620736100116de07d54532eb3"

  bottle do
    cellar :any
    sha256 "8188b7967f7c3aa44861384fa4540718a84ee1028ddd8173f4e2131c61412462" => :yosemite
    sha256 "8b819411d88a6b413a644c8b2a8e585c1e0ebfb0ec1cc474c662c90dc4c67e5c" => :mavericks
    sha256 "c5b02614ef51251e5e380afe7f91aa28b03f0d03283102490c58785efed5e590" => :mountain_lion
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

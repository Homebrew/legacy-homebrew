require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.01.10.2/youtube-dl-2015.01.10.2.tar.gz"
  sha256 "b5da9954e1309b0cad41c2d2b817e2252ed94d838b405f546f4d42f806680173"

  bottle do
    cellar :any
    sha1 "d359bd4046114c820b55c298c7b3f32aeaa57c27" => :yosemite
    sha1 "8940c2ac6b235de9815fe06762984f541304c685" => :mavericks
    sha1 "60728b78129d0187e68c3a27eb42424560e2ccb5" => :mountain_lion
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

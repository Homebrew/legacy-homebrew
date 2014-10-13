require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.10.12/youtube-dl-2014.10.12.tar.gz"
  sha1 "b280642765597dd579addedd6a0779e8b3fc20e2"

  bottle do
    cellar :any
    sha1 "a505d02d81013258b07829ea891ff910e14995b2" => :mavericks
    sha1 "87e045bb1826c6b0027c59030ad9d4ebe94cf2fd" => :mountain_lion
    sha1 "74af2e1fc06323de84645b95a8d6304fea5b0bf1" => :lion
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
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "http://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end

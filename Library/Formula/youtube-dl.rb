require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.12.06.1/youtube-dl-2014.12.06.1.tar.gz"
  sha256 "5009555b95252864d0df151775529efeef041e1c7e49be8fbeee6eb459efdd1e"

  bottle do
    cellar :any
    sha1 "111e2d37ec6c41f743eb15aa35c18ebe84a1daf3" => :yosemite
    sha1 "239663578e5e04cab3aa8ea6b5be19d55460012f" => :mavericks
    sha1 "c202ace8e0258f175ae529078b2f6d8d890b8a09" => :mountain_lion
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

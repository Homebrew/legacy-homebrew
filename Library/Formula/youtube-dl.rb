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
    sha1 "d56b7ea196ca6255ba14f198284ac7dd7bc0ca43" => :mavericks
    sha1 "5cb6f80980337ae133b7d5c25fae03d1de26d1b9" => :mountain_lion
    sha1 "eb3bcb7677d9cef89b692624543e344819ebf92e" => :lion
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

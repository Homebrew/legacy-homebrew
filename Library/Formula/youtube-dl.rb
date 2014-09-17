require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.09.16/youtube-dl-2014.09.16.tar.gz"
  sha1 "ce4de61c5d658d8b3b4762c4f5602cf2a2ae5e5b"

  bottle do
    cellar :any
    sha1 "e6a201b4b4bc21b1048f6f95e421b8576936aaa9" => :mavericks
    sha1 "3373874be447edbe79ce9a72598a0e34832b75ee" => :mountain_lion
    sha1 "599b73eb1d1c1b23f1239894e12450fc8994e3aa" => :lion
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

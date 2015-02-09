require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.02.09.2/youtube-dl-2015.02.09.2.tar.gz"
  sha256 "532b28e354bc2408b5e08cb582c69e1ce2dec0a9cf1f3efa55571532a637b362"

  bottle do
    cellar :any
    sha1 "1f0dec559861cfcdf0806b7935f0697d61d2f00f" => :yosemite
    sha1 "1eb6eb7f549c3debfe430d241adef4d0c401f18f" => :mavericks
    sha1 "cac374a97cca51899a40e4c4cb63ccec5c153706" => :mountain_lion
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

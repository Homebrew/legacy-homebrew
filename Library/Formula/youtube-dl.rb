require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.06.26/youtube-dl-2014.06.26.tar.gz"
  sha1 "5799aab2cd48ea402daf646a5168d158514a1dd4"

  bottle do
    cellar :any
    sha1 "ca41e01c42409f049651d9abb4199a3e8fce10d2" => :mavericks
    sha1 "6c77b78ef131e0c5d354d8ce90ee8503cd9029db" => :mountain_lion
    sha1 "c8eddd5282632bad3ac361006ad35358cbc9f242" => :lion
  end

  head do
    url "https://github.com/rg3/youtube-dl.git"
    depends_on "pandoc" => :build
  end

  depends_on "rtmpdump" => :optional

  def install
    # Remove the legacy executable from the git repo
    rm "youtube-dl" if build.head?
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

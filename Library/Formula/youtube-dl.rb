require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.08.23/youtube-dl-2014.08.23.tar.gz"
  sha1 "8d675ebd16fc5787e0430ebf7fa233baf7a9c780"

  bottle do
    cellar :any
    sha1 "c88162bb6e063003bb0ec3c5197bcb59c323ed02" => :mavericks
    sha1 "ee49f4b8a2715c466a8824cb2384ef9237e62bb8" => :mountain_lion
    sha1 "4d93ef3cdddfdd74da8fa171f8ade4e86552462d" => :lion
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

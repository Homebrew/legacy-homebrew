require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.08.10/youtube-dl-2014.08.10.tar.gz"
  sha1 "fd4d544f4852eb803fea7a2918b8f6e7deb89931"

  bottle do
    cellar :any
    sha1 "c1b5f8493c5a700ce740baeb5c86ee877400e619" => :mavericks
    sha1 "367f090904c3bf3953548b0b09dddaad0841ec6d" => :mountain_lion
    sha1 "774000f77e8f2a8c9aa2ddf6194729bd9ea7eab4" => :lion
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

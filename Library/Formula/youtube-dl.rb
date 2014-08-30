require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.08.29/youtube-dl-2014.08.29.tar.gz"
  sha1 "9f28a0f1ad389da6abb4e6d6af20a918eb504763"

  bottle do
    cellar :any
    sha1 "a157d91e208fc4d5d7b18d2679d636ce7e00bec3" => :mavericks
    sha1 "323d0bf9bcc8f9597af08356cf8243e836f1bf04" => :mountain_lion
    sha1 "8dd6ac1072b181f77796f5153f28d63a4c29926d" => :lion
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

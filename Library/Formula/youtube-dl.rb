require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.07.11.3/youtube-dl-2014.07.11.3.tar.gz"
  sha1 "0876f844a2553c67540138fdca098c1dbc4308b1"

  bottle do
    cellar :any
    sha1 "ebabb0d2fab9fc9e6d5e96d93b473038a2f31848" => :mavericks
    sha1 "df132175231e3620c50dbca646e8ce086fd7899b" => :mountain_lion
    sha1 "a780ebc68a497e68b64c9d7abed168c637468b95" => :lion
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

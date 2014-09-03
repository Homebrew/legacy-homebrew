require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.09.01.1/youtube-dl-2014.09.01.1.tar.gz"
  sha1 "bb320b9cbdff5048e3777e7fa30ffe2595c4e431"

  bottle do
    cellar :any
    sha1 "419ca1db3a3f9d8e3e21a58588032ce3bf49a3f7" => :mavericks
    sha1 "f45ea9a2e1de8593a6791f4ce4d922a453c66cc0" => :mountain_lion
    sha1 "cc197e90b7159433c4d6a05cef8fb1b7aa05f8f2" => :lion
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

require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.01.08/youtube-dl-2015.01.08.tar.gz"
  sha256 "937b0c1c7781da19cb4fb1b89953ac36dd6ac9bb42591ba2a1442796410cac9c"

  bottle do
    cellar :any
    sha1 "30df9cb2a3dfb65c00d96672ed788624d17234b5" => :yosemite
    sha1 "9863339a60d6d76ffedcccf3f35db6a14de98c57" => :mavericks
    sha1 "308e6ef7e8681ed0aa12a3f36e996da3311512cd" => :mountain_lion
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

require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.07.10/youtube-dl-2014.07.10.tar.gz"
  sha1 "fa2a2835e957861a99e464ad5c192efe77e93cf0"

  bottle do
    cellar :any
    sha1 "065ab1b2d2d9a88b380682dba3151179747df91e" => :mavericks
    sha1 "6ebc5a673dc24bd142f14c65f8d0648227501c37" => :mountain_lion
    sha1 "d170ac76280643f70cec0fd0b81a686cd7a504d3" => :lion
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

require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.08.02.1/youtube-dl-2014.08.02.1.tar.gz"
  sha1 "5a3d93da8725ac0cd258143b494972c3c25119bc"

  bottle do
    cellar :any
    sha1 "0a435b4df403ea8a35161df8c1d8d61c9a391a9f" => :mavericks
    sha1 "8dd9d6a2d79cd12d2e582ae05db532aab81c47d6" => :mountain_lion
    sha1 "24fab2a5080910f8a495b67a6646ef413bf0bb41" => :lion
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

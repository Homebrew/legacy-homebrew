require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.08.28.2/youtube-dl-2014.08.28.2.tar.gz"
  sha1 "4860b228793a3906be1abd4e1c7d355b34801f96"

  bottle do
    cellar :any
    sha1 "67107c0320de628c58fcd9a7e80a6ffbf3689ea5" => :mavericks
    sha1 "4486bc01ca019039020f39c56a3caa30fda783ed" => :mountain_lion
    sha1 "e0176856f82d5e991322b76a96ba848f91436b72" => :lion
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

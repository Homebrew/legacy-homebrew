require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.07.25.1/youtube-dl-2014.07.25.1.tar.gz"
  sha1 "3549e82054512557ebb126df8f92e0af25e1fa3c"

  bottle do
    cellar :any
    sha1 "9eeea615bf871478fb742cf859133235390ae403" => :mavericks
    sha1 "e67edd755aafebf2e437a5084fa70baa0f952970" => :mountain_lion
    sha1 "bbe784b1400b28078364a8167929b17e94dd8891" => :lion
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

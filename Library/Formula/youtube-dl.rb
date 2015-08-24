# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.08.23/youtube-dl-2015.08.23.tar.gz"
  sha256 "774de06d23a87a37a040399101f716c86b17d21ff78971346263217d6862757e"

  bottle do
    cellar :any
    sha256 "891da1c15bf6d42509bdb05f00e9d23ee327fbe671c45f349073504acb6197a6" => :yosemite
    sha256 "ad95b183531b27b7429d8bef7cc7251ffb23493b78e2e9e88eebe23010ab51bf" => :mavericks
    sha256 "f0da633d5749d719eec4a4dc3fab0bdc0a5b9b19eb47917f6cb1e16513a6a8a5" => :mountain_lion
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
    fish_completion.install "youtube-dl.fish"
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end

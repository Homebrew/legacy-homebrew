require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.02.16/youtube-dl-2015.02.16.tar.gz"
  sha256 "1dab1a3184197ee2e1c3ce0a06fd6aae3af06dd6e42f6f3e2eb3acb457106350"

  bottle do
    cellar :any
    sha1 "03569797052a9aff4cf614e3dc71872c90960b9e" => :yosemite
    sha1 "0041285edd5d9d7ddcbe2e384c8ae4bb33b51254" => :mavericks
    sha1 "5150eff7f47d040b811204499c3b55e2ad56103d" => :mountain_lion
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
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "http://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end

require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.12.12.4/youtube-dl-2014.12.12.4.tar.gz"
  sha256 "955740062a47842eee72a5550f37d47dba1093ed41cbf10c87f6e72c066df635"

  bottle do
    cellar :any
    sha1 "99ff7b78fb05d5c0b18416936507e74a4510fb49" => :yosemite
    sha1 "fe9023eff1073c72ca70a9ac746879bdb927c7f8" => :mavericks
    sha1 "a595989af5f882724d5a670b56e3b26606075ab0" => :mountain_lion
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

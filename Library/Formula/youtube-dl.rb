require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.11.23.1/youtube-dl-2014.11.23.1.tar.gz"
  sha256 "ebdc15e688ac787c14d3a9da18b70333166e1c50b9beed0d58b7f42b6fcb58d4"

  bottle do
    cellar :any
    sha1 "aa151ba70bf745c917b1599a04201f730b140d2e" => :yosemite
    sha1 "df35feb34554d32bfbedf5c77a5a38dfb4a4b910" => :mavericks
    sha1 "b75b947a8731b0873c2eaae732d99bbc28359759" => :mountain_lion
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

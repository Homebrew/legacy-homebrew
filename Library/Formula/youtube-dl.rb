require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.03.24/youtube-dl-2015.03.24.tar.gz"
  sha256 "bb4becd8953bad2d0b5ca20f31597d596e822197501898742ab7fdf8181486d4"

  bottle do
    cellar :any
    sha256 "36d8bac633de84aac4460f0214c629674e4b56b15510135d0c5527e400990089" => :yosemite
    sha256 "e10d8f0407f621d8decae11c7d9a930663b38c70543ab32ee7da0e5801263723" => :mavericks
    sha256 "0888b15ebb9d62093d3c12d7fef7c2bbdfb41f9b54f4a272ebe6ef643597b4db" => :mountain_lion
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

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.09.09/youtube-dl-2015.09.09.tar.gz"
  sha256 "fa2419fc47d0108b800c52dbe292fe1edf40259163035b57efb3b981e517511b"

  bottle do
    cellar :any
    sha256 "eb4df90a15719724c559e9e88202301929f19c9d14e55778672c0ac925ec4b73" => :yosemite
    sha256 "0a26108b880e0c470e36ec4deb3400348b3834a63e0f8ec0330cc1787b2fef98" => :mavericks
    sha256 "feed49aedc84c819b03395216f485aca4ad35de77f7bc9efcec7bf425913c33d" => :mountain_lion
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

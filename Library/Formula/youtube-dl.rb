# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.08.28/youtube-dl-2015.08.28.tar.gz"
  sha256 "7763dc3869804696b1f1b66cb460d578d1af8de0a73046d449803bd3ac5f5045"

  bottle do
    cellar :any
    sha256 "e60184e6a67c4b2a02a115e84c92b8d4a619a89ffbcb608f7d02147c6c1e7990" => :yosemite
    sha256 "b0de3ccd2bf442bececf93c9d2cbef843c74520cd9b14e8db4c7e7a6b7ba490d" => :mavericks
    sha256 "9e0358c50ac9a27b62811fb2fea20a48d4dc945d56dc431e1eea8cbf32cb08d9" => :mountain_lion
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

require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.02.18.1/youtube-dl-2015.02.18.1.tar.gz"
  sha256 "7eadc97c38a5d37e47a480120d760c416aead9f527107e08832f6dab9da211e3"

  bottle do
    cellar :any
    sha1 "48153a553a7ca092371ea9bd521d2b6079913515" => :yosemite
    sha1 "a157deb81c7b9d75a8331e9c3cca6bea64dbb9c4" => :mavericks
    sha1 "7d9d9c13251a785246fabe0a9cc3ffea26fbcccc" => :mountain_lion
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

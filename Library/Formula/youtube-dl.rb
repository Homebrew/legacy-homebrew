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
    sha256 "d10452baf634f4140ecdcec5bbdfbc95c7f2a410676a1b8ce6f1c9c72613b41f" => :yosemite
    sha256 "5f7331b50f1beac12b413a3b8a4b8c951d4aabd6d6255e1603d16ee24be56688" => :mavericks
    sha256 "a54a65e5c6cd933dce21550c32cfcd10974ee5d0827a37093c9d18e3be885327" => :mountain_lion
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

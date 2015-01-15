require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.01.15/youtube-dl-2015.01.15.tar.gz"
  sha256 "085ca3f752b80467f8579c08736286f956269bebdebfa8ae946225a8ad094594"

  bottle do
    cellar :any
    sha1 "165685c1c6cdbdcb42b9d4f502fcfe663dee103c" => :yosemite
    sha1 "d4d0f4ec9f9e851897c8644c1af726a337d296a4" => :mavericks
    sha1 "e473107fec1b2abc1146546eb7a38c60f808adb1" => :mountain_lion
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

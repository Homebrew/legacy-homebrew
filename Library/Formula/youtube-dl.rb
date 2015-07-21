require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.07.21/youtube-dl-2015.07.21.tar.gz"
  sha256 "0b4276ce0df1add4081ca01b5d9460ce8ac6b218fb29ec6b4ddc7130a9ff29d9"

  bottle do
    cellar :any
    revision 1
    sha256 "d4fc2c4ad4706a9df565c28150782719fa1d3fd23b9b2994df3fbe317f260132" => :yosemite
    sha256 "1f76e4aa5b659ee60cc9f28a13c0a109ef2fd2bcd966b1c695c3d725eb811e10" => :mavericks
    sha256 "7d1746d6a1b325c4b54f7247f819a8e328f6240ea7253e0efcc49d95030c0985" => :mountain_lion
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

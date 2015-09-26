# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.09.22/youtube-dl-2015.09.22.tar.gz"
  sha256 "447cb37694a5dc3b4897ac382642305526a60b6da196c2bcfcabc0ccc83764b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "c24e5b63c1669d490fabbfd3a3db6ccfc4debd29a3634c56bc3bd3e6cb5ca469" => :el_capitan
    sha256 "7bd18317421f3ffb0bebf0477fccc7077016c308fd23cdee455123bef348533a" => :yosemite
    sha256 "ec023ad1811b8fc2b050a2d5e5ed247c351fb29b2d75cc6110810bbae608f55d" => :mavericks
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

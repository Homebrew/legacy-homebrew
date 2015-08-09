# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.08.09/youtube-dl-2015.08.09.tar.gz"
  sha256 "01bd26ceb7bfde7bef2528666807241354087cf01b198b3d48623ee5e3c4b746"

  bottle do
    cellar :any
    sha256 "c002700ebb9466c4b3b350ccea5e26452fd2d1492cc55688e77a39776b5a1026" => :yosemite
    sha256 "53ebd9a211262c2975a0f7c7201ddd042d14cd96fbc265d51c7b433832d87be6" => :mavericks
    sha256 "a4aa63730cd9237439eeebc8d6a6ce09ff9e7f919b55b50e0e5eb6583b592b4e" => :mountain_lion
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

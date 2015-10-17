# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.10.16/youtube-dl-2015.10.16.tar.gz"
  sha256 "760b20f6a53b39abf2b63e2736f2315ae75710e355cf9a44e87f500f5a252a00"

  bottle do
    cellar :any_skip_relocation
    sha256 "13cf7d6984d4c32e6b32c28ebad48bce9f979c312c3c808985b0b6740ba1a2f7" => :el_capitan
    sha256 "fcebf5ef97489bb1331a0134801915700e5e49f7876c0906535e3a154fc8571a" => :yosemite
    sha256 "50c201a8944104d881f71b45f7b73682a3c10bf81f3d6e0dd15c629d65cffafb" => :mavericks
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

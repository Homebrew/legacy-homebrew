# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.10.18/youtube-dl-2015.10.18.tar.gz"
  sha256 "eece461e6af1fc030ffe29306a24676568c0310a47174168019ab1a62f08029e"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f0ed13b293f600c587d47a8ffe46744b67bd037c29d9fd2f71d60ce5ee43dfb" => :el_capitan
    sha256 "d81a5cd55923ef7ce029d4a94322c752e2f74c52a97a18facbebd4a35e3f3bf0" => :yosemite
    sha256 "f7c04e7fa8c585b89771b21b491fa8bc810d3d74a10457714130acd3eefc7196" => :mavericks
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

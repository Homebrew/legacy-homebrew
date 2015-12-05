# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.12.05/youtube-dl-2015.12.05.tar.gz"
  sha256 "ebf215a65935469609d01fc950cae38686d1c7c572369bf605cc9274e68a8fe7"

  bottle do
    cellar :any_skip_relocation
    sha256 "c679e5f5730b1b48dedd79b96ca12c1a78c0707ce55c97510c738991a7c933b9" => :el_capitan
    sha256 "4a0358c8c29ede7044a23ac5e8f0985281b835dab78f757343a86445f7d69e54" => :yosemite
    sha256 "76dc6955b52c97005129e1f9f0832e31b496dc67a0864a06c773a0f843225a95" => :mavericks
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
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=AEhULv4ruL4&list=PLZdCLR02grLrl5ie970A24kvti21hGiOf"
  end
end

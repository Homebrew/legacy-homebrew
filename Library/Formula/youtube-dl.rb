# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.12.18/youtube-dl-2015.12.18.tar.gz"
  sha256 "d3f9414fb8fdb53d4fb742d198222ea3c75854aa837eb88dcd9731c768191e8f"

  bottle do
    cellar :any_skip_relocation
    sha256 "2fff5872090f5ab23835ce25688e94ac46ece22517fd0d7938eb7435b2d6f869" => :el_capitan
    sha256 "1ec27fcb324dd979abbfd8f8057788bfe56079ead6e2a2fc3cad94d97e90436f" => :yosemite
    sha256 "d526b40e3be5bb68fac12a441628f6cc74743235994f0443689ffe4977332965" => :mavericks
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

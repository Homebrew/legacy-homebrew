# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.12.23/youtube-dl-2015.12.23.tar.gz"
  sha256 "fe7088979c78eb900c3db110a577866a01e1dd537cddda25258893f099fff9ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d58f8b3a8492a29429d6fa38cccb1f85ab03cb88e2271ef447efd0ba1a0e546" => :el_capitan
    sha256 "0074f30c0f35ffc26f5c35fd5657b695b7e09e890ed53309d71bfd77daeb9f40" => :yosemite
    sha256 "fbb75b711de486d0cea4b24dbe9957739b5d101de818d458a537a9afc87dae87" => :mavericks
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

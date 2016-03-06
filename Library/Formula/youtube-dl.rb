# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.03.06/youtube-dl-2016.03.06.tar.gz"
  sha256 "71a17b942e2418312cd5a4460824242925f52f20e112048fd26cbddc169827d1"

  bottle do
    cellar :any_skip_relocation
    sha256 "8276f05516e6e63cb30de10a6c5981701e6fff92ac91a63d411179aa8694cd58" => :el_capitan
    sha256 "fac1a450b3d35d134f0e2362e0439d184601373d34cbd8db0dbac99c96ce8575" => :yosemite
    sha256 "11b8348140f58fe8f982ed918421ab38817bff2908746d64c3bb18cd972f4186" => :mavericks
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

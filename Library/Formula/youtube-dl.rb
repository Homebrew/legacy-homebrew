# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.03.14/youtube-dl-2016.03.14.tar.gz"
  sha256 "59ad34e573ecf190cf61ebfdf91878e12fc826d422e40d85237168b88d36d7a2"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec0285ee161fb3a41b6a519491c8ae360d8dac012ff2b433d499ad2d0a6d42c7" => :el_capitan
    sha256 "953a64becdeef68ca2b1002df8d1f7f9f1120c11640927593b1f9c4fac93a51e" => :yosemite
    sha256 "ff808b34ced147e4c8af91260c281b6f1837cd2d8577998f68703265e0b15cc4" => :mavericks
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

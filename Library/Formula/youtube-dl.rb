# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.02.04/youtube-dl-2016.02.04.tar.gz"
  sha256 "77796375479a86b15170e785cc20177df4d91bdfdd871f426f24adcbc8306f05"

  bottle do
    cellar :any_skip_relocation
    sha256 "f37f36ed9e27b0052d90aa7eff61554f8d96693a4cf673df89e465fafc65f3ed" => :el_capitan
    sha256 "bdeed882850fc9565854c7905d3c37e297b0f6a30358c8dca754ef7d4840a9f7" => :yosemite
    sha256 "c6b54e87fdbcaccbcae0a1dca889e3a42f4de88d8a7cb6529b5660257131d077" => :mavericks
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

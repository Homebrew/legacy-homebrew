# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.02.01/youtube-dl-2016.02.01.tar.gz"
  sha256 "cac97ffda989b5783b7b05dd04cdb9f602089163d4c0dbeb55fc749899422613"

  bottle do
    cellar :any_skip_relocation
    sha256 "678dc5169a348d7d01d0c71b54f8d80f638648c3f29d72b9416aff1652afcfcd" => :el_capitan
    sha256 "5def828809a4309632450b8886ab3355f8922fe16cab63f8c18cbc938742f0cb" => :yosemite
    sha256 "2e6c89227167b9a1988fff038d31743eb1ea2d394bae3634253a7926709e13e9" => :mavericks
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

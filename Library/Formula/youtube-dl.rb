# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.02.05.1/youtube-dl-2016.02.05.1.tar.gz"
  sha256 "c05621cf77cfbff16c96bbe4bf07eee89d73f60b065e5daec4bb069358525f9d"

  bottle do
    cellar :any_skip_relocation
    sha256 "ecf339bfe8cb4c14a0d8fbc34d751c7c187761a1140066b09b99eb6a39001bff" => :el_capitan
    sha256 "184a186f5b06822c82bacf7e5c27a8f820841de367f9cf852d4ba5110a12823b" => :yosemite
    sha256 "92ed219678db5e1d3dcb9764a7114827b894e92730aa0f55a80c1968a1b96b32" => :mavericks
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

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.12.10/youtube-dl-2015.12.10.tar.gz"
  sha256 "5857805845f8b53e552d68ba65eb8cb9a23325c457b3a4b147b59f04c377d5bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "27773b986de9de4f0a214a58feec35e3fcef5b7a7e6cd5ae424877e19edade6a" => :el_capitan
    sha256 "7fd8305bfdf5787cf8aba8bed7b438f77eb40a431ba429bc125ef67430ed6c8a" => :yosemite
    sha256 "5c3ff5885edd4f30312ed9a4bb0da9305a6026962b3fa98d4c33d784a6252673" => :mavericks
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

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.01.27/youtube-dl-2016.01.27.tar.gz"
  sha256 "d06bb62ea19aef3ebb842ac01d98bbeee378e06d9e7c7a2f3bef343205b52ee9"

  bottle do
    cellar :any_skip_relocation
    sha256 "22d0702ed805c03d7069c30fb34d958330f302b300478a133a887099cf5e369a" => :el_capitan
    sha256 "39aeed3e6b292a10f72a9120500bcd187f308b0a2890e294f23b4a8523eaaff5" => :yosemite
    sha256 "ca48da3182009fff495cfbb705f0dc40a492209a348838957857707d7676d461" => :mavericks
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

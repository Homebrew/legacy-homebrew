# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.11.18/youtube-dl-2015.11.18.tar.gz"
  sha256 "ebc92ae887d2ff63c8091cdf7f6853d866acb39275f742ccca2352c5faf11235"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a0732d14289ca122f36a9b4ad1ea17843f3f4bf0519101d185a9dfda19f0946" => :el_capitan
    sha256 "fd59e4eab4361f37a8a73c29fd6dad9f1028ea6c668aa1282f35caf7e02db415" => :yosemite
    sha256 "bad2ffaf37f0a3c505e2e8cdb3673d020e6b6d01b70bbbde26595a9b9df7da07" => :mavericks
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

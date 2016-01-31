# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.01.31/youtube-dl-2016.01.31.tar.gz"
  sha256 "62b7e89fb4ef43eb175581dc365e1b95158d9cb30cf45c041ab9cdc96d291340"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8364cf6b68ed4d9bdedf5ef93d5bb0de1af90fcae655faf347d368e2d29274f" => :el_capitan
    sha256 "fffdff1efa5dcacc4b8f4455bef447d97ad97e3a0203bd01d8b1419c81c78976" => :yosemite
    sha256 "0a19fa8687d557a40119467d3683b5c549dd5e001d1df010a92ec2870f4f142d" => :mavericks
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

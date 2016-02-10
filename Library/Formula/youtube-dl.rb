# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2016.02.10/youtube-dl-2016.02.10.tar.gz"
  sha256 "386cfc2128eebbedf2c4ffdb41537aede509436cdb6b6ef596da4eece376d023"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8803c091ada5f7d377f35165ffed56cec91ec608a82e6b0fbdca96d28efb7e5" => :el_capitan
    sha256 "a7d0d5fed7752f3666acd19217afb4ce5b3fc04c2b8ceda232590cf890ae0b3c" => :yosemite
    sha256 "69f0a42d4aa65b7ea0afb7f07d77a830ed547555befa9bc0281dc0248eca2188" => :mavericks
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

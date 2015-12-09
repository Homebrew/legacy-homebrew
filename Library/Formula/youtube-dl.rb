# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.12.09/youtube-dl-2015.12.09.tar.gz"
  sha256 "93530a17c527cbf4e2c9e90dd98f3f43ef5a46b5daae9307a1549119c1583f87"

  bottle do
    cellar :any_skip_relocation
    sha256 "84d76944931587cccc0aae9bd6d68eecb8a83ae1bea397a9f959f16342816ad7" => :el_capitan
    sha256 "362cb0768123f744abfbbb8130169fca4b0dbbb9183e873bbd0542814ed8daf2" => :yosemite
    sha256 "80a4a5a0923cf00c11affa46baa73f5e19b4b2b9136f44aec035562ff9f11218" => :mavericks
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

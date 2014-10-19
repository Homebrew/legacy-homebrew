require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.10.18/youtube-dl-2014.10.18.tar.gz"
  sha1 "2433ecdfd07a255be5e1cdd56da1c84af881076a"

  bottle do
    cellar :any
    sha1 "aeaf12a840218d153b06c54bf55c69ba2c8fb7d3" => :yosemite
    sha1 "465ddc1092af3fc414516e68f14f03ede95dc743" => :mavericks
    sha1 "a5a839c42568bb4b0916f5315f13161fb76db5a9" => :mountain_lion
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
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "http://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end

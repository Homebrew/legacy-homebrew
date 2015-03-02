require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.02.28/youtube-dl-2015.02.28.tar.gz"
  sha256 "ac45afc0115399361807d502c3227f257882950ff650d00a73e071d60cb36a25"

  bottle do
    cellar :any
    sha1 "41a96fe081f48114d04c996b8bde42d80f1456dc" => :yosemite
    sha1 "1c55ca3a7d9069ae47824c34f706e9159592e7f9" => :mavericks
    sha1 "5ae7ece6bb65fa5a577eec264f98743ed749540b" => :mountain_lion
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
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "http://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end

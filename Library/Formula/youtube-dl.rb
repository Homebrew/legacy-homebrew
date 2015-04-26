require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.04.26/youtube-dl-2015.04.26.tar.gz"
  sha256 "0aaeeb40a4ffef3b3be3b9f73cf9deaeb60b40a09bca93f9a22520afa3144c07"

  bottle do
    cellar :any
    sha256 "74b07cf70ea475d3e587f980716b4f38623810701a40e5b715074f1736e6ca8f" => :yosemite
    sha256 "00e87d8ce9897923a222b748ee223422bc4c23591e6c1fba520198b974c4ee59" => :mavericks
    sha256 "0284338c36bdc6a313635be8bb8be17dd1bc9f0b66a6082e532e2a65cc6add8c" => :mountain_lion
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

require "formula"

# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  homepage "http://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2014.10.05.2/youtube-dl-2014.10.05.2.tar.gz"
  sha1 "defa32d81d4d88cb5ab041010ce9399d11f0763f"

  bottle do
    cellar :any
    sha1 "60d33789f82108b9a826224f481591153b291449" => :mavericks
    sha1 "79a93bf7a236e823b263d1d4a7edbbec91533c13" => :mountain_lion
    sha1 "2895d84ee087269566c79ea50281c72a48d95fff" => :lion
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
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "http://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end

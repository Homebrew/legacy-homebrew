# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.10.13/youtube-dl-2015.10.13.tar.gz"
  sha256 "4588f98ecd082ac4d1574c6bbc386eaf625fe1b2b321f4f84a2eb6bea45b41f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "607546979ea6f199a7119158f597460577361f7de56d6a0fb7d8e0cf440d1dd7" => :el_capitan
    sha256 "10c742ec77d8c5002588a7b4d4c9d28941d92f0095c1f3cb9551b2ae12186d65" => :yosemite
    sha256 "3617509fad5b18d70b1028883f7093940523f3ef6cabfeeb3adc9079aa76603a" => :mavericks
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
  end
end

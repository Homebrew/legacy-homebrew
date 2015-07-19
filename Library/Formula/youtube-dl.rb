# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"

  stable do
    url "https://pypi.python.org/packages/source/y/youtube_dl/youtube_dl-2015.07.18.tar.gz"
    sha256 "826b3e8f0752d26c1180c7cf9955fda297b2f34abfbf7e9b904f9625388bbe92"

    patch do
      url "https://github.com/rg3/youtube-dl/commit/22603348aa0b3e02c520589dea092507a04ab06a.diff"
      sha256 "393da327457786a457bd4af5e70cbd2f1a05fb5b55460812a4dba7c00946ba5e"
    end
  end

  bottle do
    cellar :any
    revision 1
    sha256 "d4fc2c4ad4706a9df565c28150782719fa1d3fd23b9b2994df3fbe317f260132" => :yosemite
    sha256 "1f76e4aa5b659ee60cc9f28a13c0a109ef2fd2bcd966b1c695c3d725eb811e10" => :mavericks
    sha256 "7d1746d6a1b325c4b54f7247f819a8e328f6240ea7253e0efcc49d95030c0985" => :mountain_lion
  end

  head do
    url "https://github.com/rg3/youtube-dl.git"
    depends_on "pandoc" => :build
  end

  depends_on "rtmpdump" => :optional

  def install
    # Avoids pandoc dependency due to patch. Revert with next relese.
    if build.stable?
      system "make", "youtube-dl", "PREFIX=#{prefix}"
    else
      system "make", "PREFIX=#{prefix}"
    end
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

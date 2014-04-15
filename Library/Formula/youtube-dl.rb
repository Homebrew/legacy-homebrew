require 'formula'

class YoutubeDl < Formula
  homepage 'http://rg3.github.io/youtube-dl/'
  # Please only update to versions that are published on PyPi as there are too
  # many releases for us to update to every single one:
  # https://pypi.python.org/pypi/youtube_dl
  url 'https://yt-dl.org/downloads/2014.04.04.7/youtube-dl-2014.04.04.7.tar.gz'
  sha1 '5f1b62eb5760fe98c0430033db83bb090f5ee9ad'

  depends_on 'rtmpdump' => :optional

  def install
    system "make", "youtube-dl", "PREFIX=#{prefix}"
    bin.install 'youtube-dl'
    man1.install 'youtube-dl.1'
    bash_completion.install 'youtube-dl.bash-completion'
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg`."
  end

  test do
    system "#{bin}/youtube-dl", '--simulate', 'http://www.youtube.com/watch?v=he2a4xK8ctk'
  end
end

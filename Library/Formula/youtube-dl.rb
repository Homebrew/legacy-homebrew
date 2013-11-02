require 'formula'

class YoutubeDl < Formula
  homepage 'http://rg3.github.io/youtube-dl/'
  url 'http://youtube-dl.org/downloads/2013.11.02/youtube-dl-2013.11.02.tar.gz'
  sha1 'c1916f7c8c9f12079d86a066e937642a4b8fc9bc'

  def install
    system "make", "youtube-dl", "PREFIX=#{prefix}"
    bin.install 'youtube-dl'
    man1.install 'youtube-dl.1'
    bash_completion.install 'youtube-dl.bash-completion'
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg`."
  end
end

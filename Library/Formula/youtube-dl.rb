require 'formula'

class YoutubeDl < Formula
  homepage 'http://rg3.github.io/youtube-dl/'
  url 'http://youtube-dl.org/downloads/2013.10.15/youtube-dl-2013.10.15.tar.gz'
  sha1 '5974bdb03e3d6d483c0517eb4c14d3b7183229ba'

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

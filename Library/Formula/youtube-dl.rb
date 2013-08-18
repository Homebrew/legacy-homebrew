require 'formula'

class YoutubeDl < Formula
  homepage 'http://rg3.github.io/youtube-dl/'
  url 'http://youtube-dl.org/downloads/2013.08.17/youtube-dl-2013.08.17.tar.gz'
  mirror 'https://github.com/rg3/youtube-dl/archive/2013.08.17.tar.gz'
  sha1 '040e08bd088d008e7cfc1c85df275eef033a75e4'

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

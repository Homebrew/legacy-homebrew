require 'formula'

class YoutubeDl < Formula
  homepage 'http://rg3.github.io/youtube-dl/'
  url 'http://youtube-dl.org/downloads/2013.07.05/youtube-dl-2013.07.05.tar.gz'
  sha1 '815e97b2a56df73842a70d086ab596a818c83cb2'

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

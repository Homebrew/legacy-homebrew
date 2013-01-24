require 'formula'

class YoutubeDl < Formula
  homepage 'http://rg3.github.com/youtube-dl/'
  url 'http://youtube-dl.org/downloads/2013.01.13/youtube-dl-2013.01.13.tar.gz'
  sha1 '99b580d1623d81f37bd022f39f1f45177b8e9c5f'

  def install
    system "make", "youtube-dl", "PREFIX=#{prefix}"
    bin.install 'youtube-dl'
    man1.install 'youtube-dl.1'
    (prefix+'etc/bash_completion.d').install 'youtube-dl.bash-completion'
  end

  def caveats
    'Install ffmpeg for using the post-processing options.'
  end
end

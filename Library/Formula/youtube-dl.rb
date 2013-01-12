require 'formula'

class YoutubeDl < Formula
  homepage 'http://rg3.github.com/youtube-dl/'
  url 'http://youtube-dl.org/downloads/2013.01.12/youtube-dl-2013.01.12.tar.gz'
  sha1 '52e3337bebe8aa9aca78a64aa254ca4d37830310'

  def install
    system "make", "youtube-dl", "PREFIX=#{prefix}"
    bin.install 'youtube-dl'
    man1.install 'youtube-dl.1'
  end
end

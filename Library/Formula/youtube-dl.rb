require 'formula'

class YoutubeDl < Formula
  homepage 'http://rg3.github.com/youtube-dl/'
  url 'http://youtube-dl.org/downloads/2013.01.06/youtube-dl-2013.01.06.tar.gz'
  sha1 'dae4d05665e1aa8401886ccf8cab0453c1394157'

  def install
    system "make", "youtube-dl", "PREFIX=#{prefix}"
    bin.install 'youtube-dl'
    man1.install 'youtube-dl.1'
  end
end

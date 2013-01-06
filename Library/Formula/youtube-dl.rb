require 'formula'

class YoutubeDl < Formula
  homepage 'http://rg3.github.com/youtube-dl/'
  url 'http://youtube-dl.org/downloads/2013.01.02/youtube-dl-2013.01.02.tar.gz'
  sha1 '30b4ece62adf26969926c370eaaa792229c3c195'

  def install
    system "make", "youtube-dl", "PREFIX=#{prefix}"
    bin.install 'youtube-dl'
    man1.install 'youtube-dl.1'
  end
end

require 'formula'

class YoutubeDl < Formula
  homepage 'http://rg3.github.com/youtube-dl/'
  url 'http://youtube-dl.org/downloads/2013.01.08/youtube-dl-2013.01.08.tar.gz'
  sha1 'ca1e2443c1a7834ee0ceca105c2fffd0cc2df462'

  def install
    system "make", "youtube-dl", "PREFIX=#{prefix}"
    bin.install 'youtube-dl'
    man1.install 'youtube-dl.1'
  end
end

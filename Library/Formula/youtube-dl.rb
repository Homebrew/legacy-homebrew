require 'formula'

class YoutubeDl < Formula
  homepage 'http://rg3.github.com/youtube-dl/'
  url 'https://github.com/rg3/youtube-dl/archive/2012.11.29.tar.gz'
  sha1 '2d13c271ef17781354f0372ca3a5ec6209892625'

  def install
    system "make", "youtube-dl", "PREFIX=#{prefix}"
    bin.install 'youtube-dl'
  end
end

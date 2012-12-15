require 'formula'

class YoutubeDl < Formula
  homepage 'http://rg3.github.com/youtube-dl/'
  url 'https://github.com/rg3/youtube-dl/archive/2012.12.11.tar.gz'
  sha1 '317904b43096ff01d6c6bbb62676912cd546809f'

  def install
    system "make", "youtube-dl", "PREFIX=#{prefix}"
    bin.install 'youtube-dl'
  end
end

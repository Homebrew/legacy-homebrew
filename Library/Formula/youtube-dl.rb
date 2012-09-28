require 'formula'

class YoutubeDl < Formula
  homepage 'http://rg3.github.com/youtube-dl/'
  url 'https://github.com/rg3/youtube-dl/tarball/2012.09.27/youtube-dl'
  sha256 '45e88c1a5b81e633bddd43d5363e7ade92af2eeb534c37a5170f4b68d73605ea'
  version '2012.09.27'

  def install
    system "make", "PREFIX=#{prefix}"
    bin.install 'youtube-dl'
  end
end

require 'formula'

class YoutubeDl < Formula
  homepage 'http://rg3.github.com/youtube-dl/'
  url 'https://github.com/rg3/youtube-dl/raw/2012.11.29/youtube-dl'
  sha256 'e5c209765a366515845fde5da9d7022ad97c29e56b4611a4dc06f5d198377991'
  version '2012.11.29'

  def install
    system "make", "PREFIX=#{prefix}"
    bin.install 'youtube-dl'
  end
end

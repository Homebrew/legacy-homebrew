require 'formula'

class YoutubeDl < Formula
  homepage 'http://rg3.github.com/youtube-dl/'
  url 'https://github.com/downloads/rg3/youtube-dl/youtube-dl.2012.12.11.tar.gz'
  sha1 '9087a85afb80b0c2e2d9f667b638b66a85686938'

  def install
    system "make", "youtube-dl", "PREFIX=#{prefix}"
    bin.install 'youtube-dl'
  end
end

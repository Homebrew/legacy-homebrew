require 'formula'

class YoutubeDl < Formula
  homepage 'http://rg3.github.com/youtube-dl/'
  url 'http://youtube-dl.org/downloads/2013.01.11/youtube-dl-2013.01.11.tar.gz'
  sha1 '6a670631bea4bccb5242e5a7bcba38758dec60c9'

  def install
    system "make", "youtube-dl", "PREFIX=#{prefix}"
    bin.install 'youtube-dl'
    man1.install 'youtube-dl.1'
  end
end

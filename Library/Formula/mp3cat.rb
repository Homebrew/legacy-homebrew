require 'formula'

class Mp3cat < Formula
  homepage 'http://tomclegg.net/mp3cat'
  url 'http://tomclegg.net/software/mp3cat-0.4.tar.gz'
  sha1 '442d2b2b546fec4535c2aa892a8fc61db21eb917'

  def install
    system "make"
    bin.install %W( mp3cat mp3log mp3log-conf mp3dirclean mp3http mp3stream-conf )
  end
end

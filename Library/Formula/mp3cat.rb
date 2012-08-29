require 'formula'

class Mp3cat < Formula
  homepage 'http://tomclegg.net/mp3cat'
  url 'http://tomclegg.net/software/mp3cat-0.4.tar.gz'
  md5 '0aa75af15c57b13aa7858092b79f3a61'

  def install
    system "make"
    bin.install %W( mp3cat mp3log mp3log-conf mp3dirclean mp3http mp3stream-conf )
  end
end

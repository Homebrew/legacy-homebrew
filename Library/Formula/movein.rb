require 'formula'

class Movein < Formula
  homepage 'http://stew.vireo.org/movein/'
  url 'http://stew.vireo.org/movein/downloads/movein-1.3.tar.gz'
  md5 'bd86f4360fb91e69168920d416a9f9d9'
  depends_on 'mr'

  def install
    bin.install ['movein']
    man1.install gzip('movein.1')
  end

  def test
    system "ls #{bin}/movein"
    system "man -P cat movein"
  end
end

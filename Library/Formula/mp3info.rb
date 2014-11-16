require 'formula'

class Mp3info < Formula
  homepage 'http://www.ibiblio.org/mp3info/'
  url 'http://www.ibiblio.org/pub/linux/apps/sound/mp3-utils/mp3info/mp3info-0.8.5a.tgz'
  sha1 '54df29eb6c2e581899affc12be698b0a71d91ca6'

  patch :p0 do
    url "https://trac.macports.org/export/34602/trunk/dports/audio/mp3info/files/patch-mp3tech.c.diff"
    sha1 "ca270ee34f87c560d0e508096a1becaae3d5feff"
  end

  def install
    system "make mp3info doc"
    bin.install "mp3info"
    man1.install "mp3info.1"
  end
end

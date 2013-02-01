require 'formula'

class Wtf < Formula
  homepage 'http://cvsweb.netbsd.org/bsdweb.cgi/src/games/wtf/'
  url 'http://mirror.aarnet.edu.au/pub/FreeBSD/ports/distfiles/wtf-20111107.tar.gz'
  sha1 'c5b280cba0c92cf6a80480375bd189a19766e628'

  def install
    inreplace %w[wtf wtf.6], "/usr/share", share
    bin.install "wtf"
    man6.install "wtf.6"
    (share+"misc").install %w[acronyms acronyms.comp]
  end
end

require 'formula'

class Wtf < Formula
  homepage 'http://cvsweb.netbsd.org/bsdweb.cgi/src/games/wtf/'
  url 'http://mirror.aarnet.edu.au/pub/FreeBSD/ports/distfiles/wtf-20130810.tar.gz'
  sha1 '9ca3e9264941273fc21744f861e583e79899a2ee'

  def install
    inreplace %w[wtf wtf.6], "/usr/share", share
    bin.install "wtf"
    man6.install "wtf.6"
    (share+"misc").install %w[acronyms acronyms.comp]
  end
end

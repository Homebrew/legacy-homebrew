require 'formula'

class Wtf <Formula
  url 'http://mirror.aarnet.edu.au/pub/FreeBSD/ports/distfiles/wtf-20080926.tar.gz'
  homepage 'http://cvsweb.netbsd.org/bsdweb.cgi/src/games/wtf/'
  md5 '5f3ad46d90a71d30ecf281dbd58e9d20'

  def install
    inreplace %w[wtf wtf.6], "/usr/share", share
    bin.install "wtf"
    man6.install "wtf.6"
    (share+"misc").install %w[acronyms acronyms.comp]
  end
end

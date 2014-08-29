require 'formula'

class Wtf < Formula
  homepage 'http://cvsweb.netbsd.org/bsdweb.cgi/src/games/wtf/'
  url 'https://downloads.sourceforge.net/project/bsdwtf/wtf-20140614.tar.gz'
  sha1 'b19b055b363acb0c53b539faa81d00c7b5c2c426'

  def install
    inreplace %w[wtf wtf.6], "/usr/share", share
    bin.install "wtf"
    man6.install "wtf.6"
    (share+"misc").install %w[acronyms acronyms.comp]
  end
end

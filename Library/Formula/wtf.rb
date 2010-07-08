require 'formula'

class Wtf <Formula
  url 'http://mirror.aarnet.edu.au/pub/FreeBSD/ports/distfiles/wtf-20080926.tar.gz'
  homepage 'http://cvsweb.netbsd.org/bsdweb.cgi/src/games/wtf/'
  md5 '5f3ad46d90a71d30ecf281dbd58e9d20'

  def patch
    inreplace 'wtf' do |contents|
      contents.gsub! /\/usr\/share/, "#{share}"
    end
  end

  def install

    bin.install "wtf"
    (man+"man6").install "wtf.6"
    (share+"misc").install "acronyms"
    (share+"misc").install "acronyms.comp"
  end
end

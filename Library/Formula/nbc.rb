require 'formula'

class Nbc <Formula
  url 'http://downloads.sourceforge.net/bricxcc/nbc-1.2.1.r3.osx.tgz'
  version '1.2.1.r3'
  homepage 'http://bricxcc.sourceforge.net/nbc/'
  md5 'd5f0bb8eb6b0474b073592ae971c87f5'

  def install
    bin.install 'NXT/nbc'
    man1.install 'doc/nbc.1'
  end
end

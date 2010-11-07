require 'formula'

class Hilite <Formula
  homepage 'http://sourceforge.net/projects/hilite/'
  url 'http://sourceforge.net/projects/hilite/files/hilite/1.5/hilite.c'
  version '1.5'
  md5 '0214a3ef553cf4cf1e41f9c3bf93ca83'

  def install
    system 'gcc hilite.c -o hilite'
    bin.install 'hilite'
  end
end

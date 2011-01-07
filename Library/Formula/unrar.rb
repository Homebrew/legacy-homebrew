require 'formula'

class Unrar <Formula
  url 'http://www.rarlab.com/rar/unrarsrc-3.9.10.tar.gz'
  md5 '3c130ae52ff9fece50af988c343e396d'
  homepage 'http://www.rarlab.com'

  def install
    system "make --makefile makefile.unix"
    bin.install 'unrar'

    mv 'license.txt', 'COPYING'
    mv 'readme.txt', 'README'
  end
end

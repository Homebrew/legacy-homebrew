require 'formula'

class Unrar < Formula
  url 'http://www.rarlab.com/rar/unrarsrc-4.1.4.tar.gz'
  sha1 'ae4b1e2c99e96527c4a97f980daa547499f42a0f'
  homepage 'http://www.rarlab.com'

  def install
    system "make --makefile makefile.unix"
    bin.install 'unrar'

    mv 'license.txt', 'COPYING'
    mv 'readme.txt', 'README'
  end
end

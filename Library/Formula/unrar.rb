require 'formula'

class Unrar < Formula
  url 'http://www.rarlab.com/rar/unrarsrc-4.2.3.tar.gz'
  sha1 '57cdee6f6c282c97ea768e88cdc5cceea4d5e62e'
  homepage 'http://www.rarlab.com'

  def install
    system "make --makefile makefile.unix"
    bin.install 'unrar'

    mv 'license.txt', 'COPYING'
    mv 'readme.txt', 'README'
  end
end

require 'formula'

class Unrar < Formula
  url 'http://www.rarlab.com/rar/unrarsrc-4.1.3.tar.gz'
  sha1 'cd9385c3297b4e0fc3c5d3e462741f1e97fbaa49'
  homepage 'http://www.rarlab.com'

  def install
    system "make --makefile makefile.unix"
    bin.install 'unrar'

    mv 'license.txt', 'COPYING'
    mv 'readme.txt', 'README'
  end
end

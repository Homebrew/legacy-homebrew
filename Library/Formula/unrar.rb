require 'formula'

class Unrar < Formula
  url 'http://www.rarlab.com/rar/unrarsrc-4.2.1.tar.gz'
  sha1 '10f48ec272f413c983032b2e0cbe4e94781c7b3b'
  homepage 'http://www.rarlab.com'

  def install
    system "make --makefile makefile.unix"
    bin.install 'unrar'

    mv 'license.txt', 'COPYING'
    mv 'readme.txt', 'README'
  end
end

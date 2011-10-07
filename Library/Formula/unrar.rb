require 'formula'

class Unrar < Formula
  url 'http://www.rarlab.com/rar/unrarsrc-4.0.7.tar.gz'
  sha1 'e4c8b0d47278475f3dfb77e8497f5818eca3d4a0'
  homepage 'http://www.rarlab.com'

  def install
    system "make --makefile makefile.unix"
    bin.install 'unrar'

    mv 'license.txt', 'COPYING'
    mv 'readme.txt', 'README'
  end
end

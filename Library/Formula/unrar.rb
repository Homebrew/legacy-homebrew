require 'formula'

class Unrar <Formula
  url 'http://www.rarlab.com/rar/unrarsrc-4.0.6.tar.gz'
  md5 '52c8b40a2f041b55baa508f2db091855'
  homepage 'http://www.rarlab.com'

  def install
    system "make --makefile makefile.unix"
    bin.install 'unrar'

    mv 'license.txt', 'COPYING'
    mv 'readme.txt', 'README'
  end
end

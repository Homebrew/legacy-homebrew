require 'formula'

class Unrar <Formula
  url 'http://www.rarlab.com/rar/unrarsrc-3.9.9.tar.gz'
  md5 '4271fc8710d299341c969666492b305c'
  homepage 'http://www.rarlab.com'

  def install
		system "make --makefile makefile.unix"
    bin.install 'unrar'
    
    mv 'license.txt', 'COPYING'
    mv 'readme.txt', 'README'
  end
end

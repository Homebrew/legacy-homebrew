require 'formula'

class Cvsps < Formula
  url 'http://www.cobite.com/cvsps/cvsps-2.2b1.tar.gz'
  homepage 'http://www.cobite.com/cvsps/'
  md5 '997580e8e283034995b9209076858c68'

  def install
    system "make cvsps"
    bin.install "cvsps"
    man1.install gzip("cvsps.1")
  end
end

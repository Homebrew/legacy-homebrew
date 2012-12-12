require 'formula'

class Cvsps < Formula
  url 'http://www.cobite.com/cvsps/cvsps-2.2b1.tar.gz'
  homepage 'http://www.cobite.com/cvsps/'
  sha1 '2e2b4504151b6f795c07d01468da7aa0b4dd03fd'

  def install
    system "make cvsps"
    bin.install "cvsps"
    man1.install gzip("cvsps.1")
  end
end

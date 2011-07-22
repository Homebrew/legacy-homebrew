require 'formula'

class Rcs < Formula
  url 'ftp://ftp.cs.purdue.edu/pub/RCS/rcs-5.7.tar.Z'
  version '5.7'
  homepage 'http://www.gnu.org/s/rcs/'
  md5 '423282f0edb353296d9f3498ab683abf'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

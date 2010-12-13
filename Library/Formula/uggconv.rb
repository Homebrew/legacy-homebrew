require 'formula'

class Uggconv < Formula
  url 'http://wyrmcorp.com/software/uggconv/uggconv-1.0.tar.gz'
  homepage 'http://wyrmcorp.com/software/uggconv/index.shtml'
  md5 '97b479b2fb761c9dbd7718b0ec71d068'

  def install
    system "make"
    bin.install 'uggconv'
    man1.install 'uggconv.1'
  end
end

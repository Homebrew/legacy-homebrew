require 'formula'

class Xdelta <Formula
  url 'http://xdelta.googlecode.com/files/xdelta3.0y.tar.gz'
  version '3.0y'
  homepage 'http://xdelta.org'
  md5 '8246e6ba89a5a6b9efc24f9552fcf940'

  def install
    system "make"
    bin.install("xdelta3")
  end
end

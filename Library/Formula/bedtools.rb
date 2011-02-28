require 'formula'

class Bedtools <Formula
  url 'http://bedtools.googlecode.com/files/BEDTools.v2.11.2.tar.gz'
  homepage 'http://code.google.com/p/bedtools/'
  md5 'f2d2b7e9ac4e92da7e0c339835a19ae4'

  def install
    system "make all"
    bin.install Dir['bin/*']
  end
end

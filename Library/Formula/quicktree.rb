require 'formula'

class Quicktree <Formula
  url 'ftp://ftp.sanger.ac.uk/pub4/resources/software/quicktree/quicktree.tar.gz'
  version '1.1'
  homepage 'http://www.sanger.ac.uk/resources/software/quicktree/'
  md5 '13331f12b35ec36904c0a01921fe96e7'

  def install
    system "make"
    bin.install "bin/quicktree"
  end
end

require 'formula'

class Perforce <Formula
  url 'http://filehost.perforce.com/perforce/r10.1/bin.darwin80u/p4'
  homepage 'http://www.perforce.com/'
  md5 'dab56a967fe688c3d5b6d25be54e9bb4'
  version '2010.1.265509'

  def install
    bin.install 'p4'
  end
end

require 'formula'

class Perforce <Formula
  url 'http://filehost.perforce.com/perforce/r09.2/bin.macosx104u/p4'
  homepage 'http://www.perforce.com/'
  md5 'eac64239d766407012e4ea9ddd5c6e6e'
  version '2009.2.238357'
  
  aka 'p4'

  def install
    bin.install 'p4'
  end
end

require 'formula'

class Perforce <Formula
  url 'http://filehost.perforce.com/perforce/r09.2/bin.macosx104u/p4'
  homepage 'http://www.perforce.com/'
  md5 '63e7c7ee9d3533173f0c4b3a8f88121e'
  version '2009.2.232252'
  
  aka 'p4'

  def install
    bin.install 'p4'
  end
end

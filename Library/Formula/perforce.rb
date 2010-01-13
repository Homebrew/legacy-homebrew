require 'formula'

class Perforce <Formula
  url 'http://filehost.perforce.com/perforce/r09.2/bin.macosx104u/p4'
  homepage 'http://www.perforce.com/'
  md5 'f0018978f6e62f4e045820918c4fb588'
  version '2009.2.228098'
  
  aka 'p4'

  def install
    bin.install 'p4'
  end
end

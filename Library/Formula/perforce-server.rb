require 'formula'

class PerforceServer <Formula
  url 'http://filehost.perforce.com/perforce/r10.1/bin.darwin80u/p4d'
  homepage 'http://www.perforce.com/'
  md5 '3fb8036d8e545e0840a3b3302aca05a5'
  version '2010.1.251161'

  aka 'p4d'

  def install
    bin.install 'p4d'
  end
end

require 'formula'

class PerforceServer < Formula
  url 'http://filehost.perforce.com/perforce/r10.1/bin.darwin80u/p4d'
  homepage 'http://www.perforce.com/'
  md5 '27660df45ac5008891e17868063de6b7'
  version '2010.1.278506'

  def install
    bin.install 'p4d'
  end
end

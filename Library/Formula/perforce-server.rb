require 'formula'

class PerforceServer < Formula
  url 'http://filehost.perforce.com/perforce/r10.2/bin.darwin90u/p4d'
  homepage 'http://www.perforce.com/'
  md5 '4603399cbbb0c128a24742ac7fcd14d9'
  version '2010.2.347035'

  def install
    bin.install 'p4d'
  end
end

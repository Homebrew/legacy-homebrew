require 'formula'

class PerforceServer < Formula
  url 'http://filehost.perforce.com/perforce/r10.2/bin.darwin90u/p4d'
  homepage 'http://www.perforce.com/'
  md5 'ec899caca75736d85a19ab99e9e37fdd'
  version '2010.2.322263'

  def install
    bin.install 'p4d'
  end
end

require 'formula'

class PerforceServer < Formula
  homepage 'http://www.perforce.com/'

  if MacOS.prefer_64_bit?
    url 'http://filehost.perforce.com/perforce/r12.2/bin.darwin90x86_64/p4d'
    version '2012.2.538478-x86_64'
    sha1 'c040e5a9182687a1d2e2f1027c9039d7c47fc5eb'
  else
    url 'http://filehost.perforce.com/perforce/r12.2/bin.darwin90x86/p4d'
    version '2012.2.538478-x86'
    sha1 'bd2771acca2091292d85a6384a756e986383de06'
  end

  def install
    bin.install 'p4d'
  end
end

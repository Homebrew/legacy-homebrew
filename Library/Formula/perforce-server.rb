require 'formula'

class PerforceServer < Formula
  homepage 'http://www.perforce.com/'

  if MacOS.prefer_64_bit?
    url 'http://filehost.perforce.com/perforce/r12.2/bin.darwin90x86_64/p4d'
    version '2012.2.551823-x86_64'
    sha1 'df326fc5d88bdd9ab4a6fe77a86f7100b0935958'
  else
    url 'http://filehost.perforce.com/perforce/r12.2/bin.darwin90x86/p4d'
    version '2012.2.551823-x86'
    sha1 'd70a8d19c86b75286ed5bba54241992931196f0e'
  end

  def install
    bin.install 'p4d'
  end
end

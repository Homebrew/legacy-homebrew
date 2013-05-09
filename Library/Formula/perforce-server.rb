require 'formula'

class PerforceServer < Formula
  homepage 'http://www.perforce.com/'

  if MacOS.prefer_64_bit?
    url 'http://filehost.perforce.com/perforce/r12.2/bin.darwin90x86_64/p4d'
    version '2012.2.631250-x86_64'
    sha1 '21d5a904321a95026fe65890b9d9cb4043eaf84c'
  else
    url 'http://filehost.perforce.com/perforce/r12.2/bin.darwin90x86/p4d'
    version '2012.2.631250-x86'
    sha1 '97fae79520e2801f18600362e24eaee6d47497c0'
  end

  def install
    bin.install 'p4d'
  end
end

require 'formula'

class PerforceServer < Formula
  homepage 'http://www.perforce.com/'

  if MacOS.prefer_64_bit?
    url 'http://filehost.perforce.com/perforce/r12.2/bin.darwin90x86_64/p4d'
    version '2012.2.607384-x86_64'
    sha1 '012210ec2560a5e76e5942eec6baf35f861da83e'
  else
    url 'http://filehost.perforce.com/perforce/r12.2/bin.darwin90x86/p4d'
    version '2012.2.607384-x86'
    sha1 '4d236a42409a620cd89e8802dba37fdecc16c6db'
  end

  def install
    bin.install 'p4d'
  end
end

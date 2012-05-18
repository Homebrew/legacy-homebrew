require 'formula'

class Perforce < Formula
  homepage 'http://www.perforce.com/'

  if MacOS.prefer_64_bit?
    url 'http://filehost.perforce.com/perforce/r12.1/bin.darwin90x86_64/p4'
    md5 'fb51515f7b94b871c62a04a8d4b86c19'
    version '2012.1.459601-x86_64'
  else
    url 'http://filehost.perforce.com/perforce/r12.1/bin.darwin90x86/p4'
    md5 'b47e583d158900ccdf49634686dd70de'
    version '2012.1.459601-x86'
  end

  def install
    bin.install 'p4'
  end
end

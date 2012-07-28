require 'formula'

class Perforce < Formula
  homepage 'http://www.perforce.com/'

  if MacOS.prefer_64_bit?
    url 'http://filehost.perforce.com/perforce/r12.2/bin.darwin90x86_64/p4'
    version '2012.1.473528-x86_64'
    sha1 '4f46c3c6410cc34bbd9eabbc361c1065534b8ab7'
  else
    url 'http://filehost.perforce.com/perforce/r12.2/bin.darwin90x86/p4'
    version '2012.1.473528-x86'
    sha1 '63e4feb2e955256044f6b390876bfb5b13d05142'
  end

  def install
    bin.install 'p4'
  end
end

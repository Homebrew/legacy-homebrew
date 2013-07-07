require 'formula'

class Perforce < Formula
  homepage 'http://www.perforce.com/'

  if MacOS.prefer_64_bit?
    url 'http://filehost.perforce.com/perforce/r13.1/bin.darwin90x86_64/p4'
    version '2013.1.659207-x86_64'
    sha1 '4bba9ba354a82d62b6569d1df41b49fc5731cb52'
  else
    url 'http://filehost.perforce.com/perforce/r13.1/bin.darwin90x86/p4'
    version '2013.1.659207-x86'
    sha1 '1e275a4b8c22338066ad2f48433de813a8aae101'
  end

  def install
    bin.install 'p4'
  end
end

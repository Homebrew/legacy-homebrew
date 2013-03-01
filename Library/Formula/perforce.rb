require 'formula'

class Perforce < Formula
  homepage 'http://www.perforce.com/'

  if MacOS.prefer_64_bit?
    url 'http://filehost.perforce.com/perforce/r12.2/bin.darwin90x86_64/p4'
    version '2012.2.536738-x86_64'
    sha1 '6ecdbd5559ea4d04cddf81d76afe71e5cbe2baee'
  else
    url 'http://filehost.perforce.com/perforce/r12.2/bin.darwin90x86/p4'
    version '2012.2.536738-x86'
    sha1 'e1271c312a822eeb3a2fe6f0380f3599ed230aa5'
  end

  def install
    bin.install 'p4'
  end
end

require 'formula'

class Perforce < Formula
  homepage 'http://www.perforce.com/'

  if MacOS.prefer_64_bit?
    url 'http://filehost.perforce.com/perforce/r12.1/bin.darwin90x86_64/p4'
    version '2012.1.459601-x86_64'
    sha1 '536d43c3fc0560da5aeacbd2bd3405891c442066'
  else
    url 'http://filehost.perforce.com/perforce/r12.1/bin.darwin90x86/p4'
    version '2012.1.459601-x86'
    sha1 'c10768ca3b6d7b8d1a2558b4b9fb965d2148523f'
  end

  def install
    bin.install 'p4'
  end
end

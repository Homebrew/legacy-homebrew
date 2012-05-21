require 'formula'

class PerforceServer < Formula
  homepage 'http://www.perforce.com/'

  if MacOS.prefer_64_bit?
    url 'http://filehost.perforce.com/perforce/r12.1/bin.darwin90x86_64/p4d'
    md5 '30779829f7bdfdea5c57c5018e7cff35'
    version '2012.1.459601-x86_64'
  else
    url 'http://filehost.perforce.com/perforce/r12.1/bin.darwin90x86/p4d'
    md5 '4bae8014aa541b453e524f65cfb15dcc'
    version '2012.1.459601-x86'
  end

  def install
    bin.install 'p4d'
  end
end

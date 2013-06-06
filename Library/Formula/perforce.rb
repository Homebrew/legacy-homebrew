require 'formula'

class Perforce < Formula
  homepage 'http://www.perforce.com/'

  if MacOS.prefer_64_bit?
    url 'http://filehost.perforce.com/perforce/r12.2/bin.darwin90x86_64/p4'
    version '2012.2.631250-x86_64'
    sha1 'bd294fae92a0b9e450000a7e6a793aec9839aa58'
  else
    url 'http://filehost.perforce.com/perforce/r12.2/bin.darwin90x86/p4'
    version '2012.2.631250-x86'
    sha1 '38fba9371be46e5b163291d826efb1eca94d046f'
  end

  def install
    bin.install 'p4'
  end
end

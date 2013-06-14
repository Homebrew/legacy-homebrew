require 'formula'

class Perforce < Formula
  homepage 'http://www.perforce.com/'

  if MacOS.prefer_64_bit?
    url 'http://filehost.perforce.com/perforce/r13.1/bin.darwin90x86_64/p4'
    version '2013.1.610569-x86_64'
    sha1 '8a8b349dc698699b125185e285303a4c855c4cd2'
  else
    url 'http://filehost.perforce.com/perforce/r13.1/bin.darwin90x86/p4'
    version '2013.1.610569-x86'
    sha1 '78998ee6875056bd1a367a5aea9d1d76ff2e7c1f'
  end

  def install
    bin.install 'p4'
  end
end

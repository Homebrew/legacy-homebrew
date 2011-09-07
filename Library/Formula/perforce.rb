require 'formula'

class Perforce < Formula
  url 'http://filehost.perforce.com/perforce/r10.2/bin.darwin90u/p4'
  homepage 'http://www.perforce.com/'
  md5 'fc5d151d1b8be6e2633b75f6ac98e51a'
  version '2010.2.295040'

  def install
    bin.install 'p4'
  end
end

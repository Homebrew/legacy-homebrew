require 'formula'

class Unar <Formula
  url 'http://theunarchiver.googlecode.com/files/unar0.2.zip'
  homepage 'http://wakaba.c3.cx/s/apps/unarchiver'
  version '0.2'
  md5 'c43a4c642e094493961f4650f3a5ebab'

  def install
    bin.install ['lsar', 'unar']
  end
end
